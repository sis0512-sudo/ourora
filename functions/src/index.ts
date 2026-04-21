import { HttpsError, onCall } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import { defineSecret } from "firebase-functions/params";
import { initializeApp } from "firebase-admin/app";
import { FieldValue, getFirestore } from "firebase-admin/firestore";

const youtubeApiKey = defineSecret("YOUTUBE_API_KEY");
const instagramAccessToken = defineSecret("INSTAGRAM_ACCESS_TOKEN");
const instagramUserId = "17841407845566676";
const instagramFields = "id,media_type,media_url,thumbnail_url,permalink,timestamp,caption";
const instagramPageSize = 9;
const instagramCacheTtlMs = 60 * 60 * 1000;

initializeApp();
const db = getFirestore("ourora");

interface YoutubeApiResponse {
  items: YoutubeApiItem[];
}

interface YoutubeApiItem {
  id: string;
  snippet: {
    title: string;
    description?: string;
    thumbnails?: {
      high?: { url?: string };
      medium?: { url?: string };
      default?: { url?: string };
    };
  };
  contentDetails?: {
    duration?: string;
  };
}

interface InstagramApiResponse {
  data: InstagramApiItem[];
  paging?: {
    next?: string;
    cursors?: {
      after?: string;
    };
  };
}

interface InstagramApiItem {
  id: string;
  media_type: string;
  media_url?: string;
  thumbnail_url?: string;
  permalink?: string;
  timestamp?: string;
  caption?: string;
}

export const fetchYoutubeVideosCallable = onCall(
  { region: "asia-northeast3", secrets: [youtubeApiKey] },
  async (request) => {
    const rawVideoIds = request.data?.videoIds;
    const videoIds = Array.isArray(rawVideoIds)
      ? rawVideoIds.filter((id): id is string => typeof id === "string" && id.trim().length > 0)
      : [];

    if (videoIds.length === 0) {
      throw new HttpsError("invalid-argument", "videoIds must be a non-empty string array");
    }

    try {
      const apiKey = youtubeApiKey.value();
      if (!apiKey) {
        logger.error("Missing YOUTUBE_API_KEY");
        throw new HttpsError("failed-precondition", "YouTube API key is not configured");
      }

      const ids = videoIds.join(",");
      const url =
        "https://www.googleapis.com/youtube/v3/videos" +
        `?id=${ids}&part=snippet,contentDetails&key=${apiKey}`;

      const res = await fetch(url);
      const responseBody = await res.text();
      if (!res.ok) {
        logger.error("YouTube API request failed", {
          status: res.status,
          statusText: res.statusText,
          responseBody: truncate(responseBody, 1000),
        });
        throw new HttpsError("internal", `YouTube API 오류: ${res.status} ${res.statusText}`);
      }

      const data = JSON.parse(responseBody) as YoutubeApiResponse;
      const videos = (data.items ?? []).map((item) => ({
        videoId: item.id,
        title: item.snippet?.title ?? "",
        description: item.snippet?.description ?? "",
        thumbnailUrl:
          item.snippet?.thumbnails?.high?.url ??
          item.snippet?.thumbnails?.medium?.url ??
          item.snippet?.thumbnails?.default?.url ??
          "",
        duration: item.contentDetails?.duration ?? "00:00",
      }));

      const batch = db.batch();
      for (const video of videos) {
        const ref = db.collection("youtube_videos").doc(video.videoId);
        batch.set(
          ref,
          {
            title: video.title,
            description: video.description,
            thumbnailUrl: video.thumbnailUrl,
            duration: video.duration,
            updatedAt: FieldValue.serverTimestamp(),
          },
          { merge: true }
        );
      }
      await batch.commit();

      logger.info("YouTube videos fetched and cached", {
        requestedCount: videoIds.length,
        fetchedCount: videos.length,
      });

      return { videos };
    } catch (e) {
      const message = getErrorMessage(e);
      logger.error("Unhandled error in fetchYoutubeVideosCallable", { error: message });
      if (e instanceof HttpsError) throw e;
      throw new HttpsError("internal", "Unexpected error while fetching YouTube videos");
    }
  }
);

function getErrorMessage(e: unknown): string {
  if (e instanceof Error) return `${e.name}: ${e.message}`;
  return String(e);
}

function truncate(value: string, max: number): string {
  if (value.length <= max) return value;
  return `${value.slice(0, max)}...`;
}

export const fetchInstagramPage = onCall(
  { region: "asia-northeast3", secrets: [instagramAccessToken] },
  async (request) => {
    const rawAfterCursor = request.data?.afterCursor;
    const afterCursor = typeof rawAfterCursor === "string" ? rawAfterCursor : undefined;
    const cacheDocId = getInstagramCacheDocId(afterCursor);
    const cacheDocRef = db.collection("instagram_page_cache").doc(cacheDocId);

    const cachedSnap = await cacheDocRef.get();
    if (cachedSnap.exists) {
      const cachedData = cachedSnap.data();
      const fetchedAt = cachedData?.fetchedAt?.toDate?.() as Date | undefined;
      if (fetchedAt && Date.now() - fetchedAt.getTime() <= instagramCacheTtlMs) {
        logger.info("Returning cached Instagram page", {
          cacheDocId,
          afterCursor: afterCursor ?? null,
          fetchedAt: fetchedAt.toISOString(),
        });

        return {
          posts: (cachedData?.posts as unknown[] | undefined) ?? [],
          nextCursor: (cachedData?.nextCursor as string | null | undefined) ?? null,
        };
      }
    }

    const accessToken = instagramAccessToken.value();
    if (!accessToken) {
      logger.error("Missing INSTAGRAM_ACCESS_TOKEN");
      throw new HttpsError("failed-precondition", "Instagram access token is not configured");
    }

    const collected: InstagramApiItem[] = [];
    let cursor: string | undefined = afterCursor;
    let hasMore = true;

    while (collected.length < instagramPageSize && hasMore) {
      const params = new URLSearchParams({
        fields: instagramFields,
        access_token: accessToken,
        limit: `${instagramPageSize}`,
      });
      if (cursor) params.set("after", cursor);

      const url = `https://graph.instagram.com/${instagramUserId}/media?${params.toString()}`;
      const response = await fetch(url);
      const responseBody = await response.text();
      if (!response.ok) {
        logger.error("Instagram API request failed", {
          status: response.status,
          statusText: response.statusText,
          responseBody: truncate(responseBody, 1000),
        });
        throw new HttpsError("internal", "Instagram API request failed");
      }

      const data = JSON.parse(responseBody) as InstagramApiResponse;
      const items = data.data ?? [];
      const filtered = items.filter((item) => item.media_url && item.media_type !== "VIDEO");
      collected.push(...filtered);

      hasMore = Boolean(data.paging?.next);
      cursor = hasMore ? data.paging?.cursors?.after : undefined;
    }

    const posts = collected.slice(0, instagramPageSize).map((item) => ({
      id: item.id,
      mediaType: item.media_type,
      mediaUrl: item.media_url ?? "",
      thumbnailUrl: item.thumbnail_url ?? null,
      permalink: item.permalink ?? "",
      timestamp: item.timestamp ?? "",
      caption: item.caption ?? null,
    }));

    await cacheDocRef.set(
      {
        cacheDocId,
        afterCursor: afterCursor ?? null,
        posts,
        nextCursor: cursor ?? null,
        fetchedAt: FieldValue.serverTimestamp(),
      },
      { merge: true }
    );

    return {
      posts,
      nextCursor: cursor ?? null,
    };
  }
);

function getInstagramCacheDocId(afterCursor?: string): string {
  if (!afterCursor) return "first_page";
  return `after_${Buffer.from(afterCursor).toString("base64url")}`;
}
