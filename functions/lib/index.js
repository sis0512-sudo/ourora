"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.fetchYoutubeVideos = void 0;
const admin = require("firebase-admin");
const firestore_1 = require("firebase-admin/firestore");
const firestore_2 = require("firebase-functions/v2/firestore");
const logger = require("firebase-functions/logger");
const params_1 = require("firebase-functions/params");
admin.initializeApp();
const youtubeApiKey = (0, params_1.defineSecret)("YOUTUBE_API_KEY");
exports.fetchYoutubeVideos = (0, firestore_2.onDocumentCreated)({
    document: "youtube_fetch_requests/{requestId}",
    database: "ourora",
    region: "asia-northeast3",
    secrets: [youtubeApiKey],
}, async (event) => {
    const requestRef = event.data?.ref;
    if (!requestRef)
        return;
    const requestId = event.params.requestId;
    const videoIds = event.data?.data()?.videoIds ?? [];
    logger.info("fetchYoutubeVideos triggered", { requestId, videoCount: videoIds.length, videoIds });
    if (videoIds.length === 0) {
        await requestRef.update({
            status: "error",
            error: "videoIds가 비어있습니다",
            errorCode: "EMPTY_VIDEO_IDS",
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        return;
    }
    const db = (0, firestore_1.getFirestore)("ourora");
    try {
        const apiKey = youtubeApiKey.value();
        if (!apiKey) {
            await requestRef.update({
                status: "error",
                error: "YOUTUBE_API_KEY가 설정되지 않았습니다",
                errorCode: "MISSING_API_KEY",
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            });
            logger.error("Missing YOUTUBE_API_KEY", { requestId });
            return;
        }
        const ids = videoIds.join(",");
        const url = `https://www.googleapis.com/youtube/v3/videos` +
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
            await requestRef.update({
                status: "error",
                error: `YouTube API 오류: ${res.status} ${res.statusText}`,
                errorCode: "YOUTUBE_API_HTTP_ERROR",
                httpStatus: res.status,
                responseBody: truncate(responseBody, 2000),
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            });
            return;
        }
        const data = JSON.parse(responseBody);
        const batch = db.batch();
        let savedCount = 0;
        for (const item of data.items ?? []) {
            const { snippet, contentDetails } = item;
            const thumbnails = snippet.thumbnails;
            const thumbnail = thumbnails.high ?? thumbnails.medium ?? thumbnails.default;
            batch.set(db.collection("youtube_videos").doc(item.id), {
                videoId: item.id,
                title: snippet.title,
                description: snippet.description ?? "",
                thumbnailUrl: thumbnail?.url ?? "",
                duration: parseDuration(contentDetails.duration),
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            });
            savedCount++;
        }
        await batch.commit();
        logger.info("YouTube videos saved", { requestId, requestedCount: videoIds.length, savedCount });
        await requestRef.update({
            status: "completed",
            requestedCount: videoIds.length,
            savedCount,
            missingVideoIds: videoIds.filter((id) => !(data.items ?? []).some((item) => item.id === id)),
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
    }
    catch (e) {
        const message = getErrorMessage(e);
        logger.error("Unhandled error in fetchYoutubeVideos", { requestId, error: message });
        await requestRef.update({
            status: "error",
            error: message,
            errorCode: "UNHANDLED_EXCEPTION",
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        throw e;
    }
});
function parseDuration(iso) {
    const match = /PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?/.exec(iso);
    if (!match)
        return "00:00";
    const h = parseInt(match[1] ?? "0") || 0;
    const m = parseInt(match[2] ?? "0") || 0;
    const s = parseInt(match[3] ?? "0") || 0;
    if (h > 0) {
        return [h, m, s].map((n) => String(n).padStart(2, "0")).join(":");
    }
    return [m, s].map((n) => String(n).padStart(2, "0")).join(":");
}
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
//# sourceMappingURL=index.js.map