"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.fetchYoutubeVideos = void 0;
const firestore_1 = require("firebase-functions/v2/firestore");
const logger = require("firebase-functions/logger");
const params_1 = require("firebase-functions/params");
const youtubeApiKey = (0, params_1.defineSecret)("YOUTUBE_API_KEY");
exports.fetchYoutubeVideos = (0, firestore_1.onDocumentCreated)({
    document: "youtube_fetch_requests/{requestId}",
    database: "ourora",
    region: "asia-northeast3",
    secrets: [youtubeApiKey],
}, async (event) => {
    const snapshot = event.data;
    if (!snapshot)
        return;
    const requestId = event.params.requestId;
    const videoIds = snapshot.data()?.videoIds ?? [];
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
            throw new Error(`YouTube API 오류: ${res.status} ${res.statusText}`);
        }
        const data = JSON.parse(responseBody);
        const fetchedIds = (data.items ?? []).map((item) => item.id);
        const missingVideoIds = videoIds.filter((id) => !fetchedIds.includes(id));
        logger.info("YouTube API fetch completed (no DB write mode)", {
            requestId,
            requestedCount: videoIds.length,
            fetchedCount: fetchedIds.length,
            fetchedIds,
            missingVideoIds,
        });
    }
    catch (e) {
        const message = getErrorMessage(e);
        logger.error("Unhandled error in fetchYoutubeVideos", { requestId, error: message });
        throw e;
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
//# sourceMappingURL=index.js.map