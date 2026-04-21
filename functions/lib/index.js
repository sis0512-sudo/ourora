"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.fetchInstagramPage = exports.fetchYoutubeVideosCallable = void 0;
const https_1 = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const params_1 = require("firebase-functions/params");
const app_1 = require("firebase-admin/app");
const firestore_1 = require("firebase-admin/firestore");
const youtubeApiKey = (0, params_1.defineSecret)("YOUTUBE_API_KEY");
const instagramAccessToken = (0, params_1.defineSecret)("INSTAGRAM_ACCESS_TOKEN");
const instagramUserId = "17841407845566676";
const instagramFields = "id,media_type,media_url,thumbnail_url,permalink,timestamp,caption";
const instagramPageSize = 9;
(0, app_1.initializeApp)();
const db = (0, firestore_1.getFirestore)("ourora");
exports.fetchYoutubeVideosCallable = (0, https_1.onCall)({ region: "asia-northeast3", secrets: [youtubeApiKey] }, async (request) => {
    const rawVideoIds = request.data?.videoIds;
    const videoIds = Array.isArray(rawVideoIds)
        ? rawVideoIds.filter((id) => typeof id === "string" && id.trim().length > 0)
        : [];
    if (videoIds.length === 0) {
        throw new https_1.HttpsError("invalid-argument", "videoIds must be a non-empty string array");
    }
    try {
        const apiKey = youtubeApiKey.value();
        if (!apiKey) {
            logger.error("Missing YOUTUBE_API_KEY");
            throw new https_1.HttpsError("failed-precondition", "YouTube API key is not configured");
        }
        const ids = videoIds.join(",");
        const url = `https://www.googleapis.com/youtube/v3/videos` +
            `?id=${ids}&part=snippet,contentDetails&key=${apiKey}`;
        const res = await fetch(url);
        const responseBody = await res.text();
        if (!res.ok) {
            logger.error("YouTube API request failed", {
                status: res.status,
                statusText: res.statusText,
                responseBody: truncate(responseBody, 1000),
            });
            throw new https_1.HttpsError("internal", `YouTube API 오류: ${res.status} ${res.statusText}`);
        }
        const data = JSON.parse(responseBody);
        const videos = (data.items ?? []).map((item) => ({
            videoId: item.id,
            title: item.snippet?.title ?? "",
            description: item.snippet?.description ?? "",
            thumbnailUrl: item.snippet?.thumbnails?.high?.url ??
                item.snippet?.thumbnails?.medium?.url ??
                item.snippet?.thumbnails?.default?.url ??
                "",
            duration: item.contentDetails?.duration ?? "00:00",
        }));
        const batch = db.batch();
        for (const video of videos) {
            const ref = db.collection("youtube_videos").doc(video.videoId);
            batch.set(ref, {
                title: video.title,
                description: video.description,
                thumbnailUrl: video.thumbnailUrl,
                duration: video.duration,
                updatedAt: firestore_1.FieldValue.serverTimestamp(),
            }, { merge: true });
        }
        await batch.commit();
        logger.info("YouTube videos fetched and cached", {
            requestedCount: videoIds.length,
            fetchedCount: videos.length,
        });
        return { videos };
    }
    catch (e) {
        const message = getErrorMessage(e);
        logger.error("Unhandled error in fetchYoutubeVideosCallable", { error: message });
        if (e instanceof https_1.HttpsError)
            throw e;
        throw new https_1.HttpsError("internal", "Unexpected error while fetching YouTube videos");
    }
});
function getErrorMessage(e) {
    if (e instanceof Error)
        return `${e.name}: ${e.message}`;
    return String(e);
}
function truncate(value, max) {
    if (value.length <= max)
        return value;
    return `${value.slice(0, max)}...`;
}
exports.fetchInstagramPage = (0, https_1.onCall)({ region: "asia-northeast3", secrets: [instagramAccessToken] }, async (request) => {
    const rawAfterCursor = request.data?.afterCursor;
    const afterCursor = typeof rawAfterCursor === "string" ? rawAfterCursor : undefined;
    const accessToken = instagramAccessToken.value();
    if (!accessToken) {
        logger.error("Missing INSTAGRAM_ACCESS_TOKEN");
        throw new https_1.HttpsError("failed-precondition", "Instagram access token is not configured");
    }
    const collected = [];
    let cursor = afterCursor;
    let hasMore = true;
    while (collected.length < instagramPageSize && hasMore) {
        const params = new URLSearchParams({
            fields: instagramFields,
            access_token: accessToken,
            limit: `${instagramPageSize}`,
        });
        if (cursor)
            params.set("after", cursor);
        const url = `https://graph.instagram.com/${instagramUserId}/media?${params.toString()}`;
        const response = await fetch(url);
        const responseBody = await response.text();
        if (!response.ok) {
            logger.error("Instagram API request failed", {
                status: response.status,
                statusText: response.statusText,
                responseBody: truncate(responseBody, 1000),
            });
            throw new https_1.HttpsError("internal", "Instagram API request failed");
        }
        const data = JSON.parse(responseBody);
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
});
//# sourceMappingURL=index.js.map