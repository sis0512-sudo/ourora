import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import { defineSecret } from "firebase-functions/params";

const youtubeApiKey = defineSecret("YOUTUBE_API_KEY");
const instagramAccessToken = defineSecret("INSTAGRAM_ACCESS_TOKEN");
const instagramUserId = "17841407845566676";
const instagramFields = "id,media_type,media_url,thumbnail_url,permalink,timestamp,caption";
const instagramPageSize = 9;

interface YoutubeApiResponse {
  items: YoutubeApiItem[];
}

interface YoutubeApiItem {
  id: string;
  snippet: {
    title: string;
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

export const fetchYoutubeVideos = onDocumentCreated(
  {
    document: "youtube_fetch_requests/{requestId}",
    database: "ourora",
    region: "asia-northeast3",
    secrets: [youtubeApiKey],
  },
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) return;

    const requestId = event.params.requestId;
    const videoIds: string[] = snapshot.data()?.videoIds ?? [];
    logger.info("fetchYoutubeVideos triggered", { requestId, videoCount: videoIds.length, videoIds });

    if (videoIds.length === 0) {
      logger.warn("Empty videoIds; skipping YouTube fetch", { requestId });
      return;
    }

    try {
      const apiKey = youtubeApiKey.value();
      if (!apiKey) {
        logger.error("Missing YOUTUBE_API_KEY", { requestId });
        return;
      }

      const ids = videoIds.join(",");
      const url =
        `https://www.googleapis.com/youtube/v3/videos` +
        `?id=${ids}&part=snippet,contentDetails&key=${apiKey}`;

      const res = await fetch(url);
      const responseBody = await res.text();
      if (!res.ok) {
        logger.error("YouTube API request failed", {
          requestId,
          status: res.status,
          statusText: res.statusText,
          responseBody: truncate(responseBody, 1000),
        });
        throw new Error(`YouTube API 오류: ${res.status} ${res.statusText}`);
      }

      const data = JSON.parse(responseBody) as YoutubeApiResponse;
      const fetchedIds = (data.items ?? []).map((item) => item.id);
      const missingVideoIds = videoIds.filter((id) => !fetchedIds.includes(id));
      logger.info("YouTube API fetch completed (no DB write mode)", {
        requestId,
        requestedCount: videoIds.length,
        fetchedCount: fetchedIds.length,
        fetchedIds,
        missingVideoIds,
      });
    } catch (e) {
      const message = getErrorMessage(e);
      logger.error("Unhandled error in fetchYoutubeVideos", { requestId, error: message });
      throw e;
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

    return {
      posts,
      nextCursor: cursor ?? null,
    };
  }
);
