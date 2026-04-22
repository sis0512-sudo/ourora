"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ogRender = exports.fetchInstagramPage = exports.fetchYoutubeVideosCallable = void 0;
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
const instagramCacheTtlMs = 60 * 60 * 1000;
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
        const url = "https://www.googleapis.com/youtube/v3/videos" +
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
    const cacheDocId = getInstagramCacheDocId(afterCursor);
    const cacheDocRef = db.collection("instagram_page_cache").doc(cacheDocId);
    const cachedSnap = await cacheDocRef.get();
    if (cachedSnap.exists) {
        const cachedData = cachedSnap.data();
        const fetchedAt = cachedData?.fetchedAt?.toDate?.();
        if (fetchedAt && Date.now() - fetchedAt.getTime() <= instagramCacheTtlMs) {
            logger.info("Returning cached Instagram page", {
                cacheDocId,
                afterCursor: afterCursor ?? null,
                fetchedAt: fetchedAt.toISOString(),
            });
            return {
                posts: cachedData?.posts ?? [],
                nextCursor: cachedData?.nextCursor ?? null,
            };
        }
    }
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
    await cacheDocRef.set({
        cacheDocId,
        afterCursor: afterCursor ?? null,
        posts,
        nextCursor: cursor ?? null,
        fetchedAt: firestore_1.FieldValue.serverTimestamp(),
    }, { merge: true });
    return {
        posts,
        nextCursor: cursor ?? null,
    };
});
function getInstagramCacheDocId(afterCursor) {
    if (!afterCursor)
        return "first_page";
    return `after_${Buffer.from(afterCursor).toString("base64url")}`;
}
// ─── OG Render ───────────────────────────────────────────────────────────────
const HOSTING_URL = "https://www.ourorastudio.com";
const HOSTING_FETCH_URL = "https://ourora-78e54.web.app";
const DEFAULT_OG_IMAGE = "https://firebasestorage.googleapis.com/v0/b/ourora-78e54.firebasestorage.app/o/images%2Flogo.png?alt=media&token=741d2b5e-5306-410f-bec4-d63f70786e46";
function getOgMetaForPath(path) {
    const base = path.split("?")[0];
    const common = { image: DEFAULT_OG_IMAGE, type: "website" };
    if (base === "/about")
        return { ...common, title: "공방 소개 | OURORA STUDIO", description: "목동의 가구공방 오로라공방을 소개합니다. 손으로 가구를 만드는 즐거움, 오로라공방에서 시작하세요.", url: `${HOSTING_URL}/about` };
    if (base === "/fidp")
        return { ...common, title: "F·I·D·P | OURORA STUDIO", description: "Form, Innovation, Design, Philosophy. 오로라공방이 추구하는 네 가지 핵심 가치입니다.", url: `${HOSTING_URL}/fidp` };
    if (base === "/works" || base.startsWith("/works/"))
        return { ...common, title: "작품 갤러리 | OURORA STUDIO", description: "오로라공방에서 만든 가구 작품들을 감상하세요. 원목 가구, 목공예 작품 갤러리입니다.", url: `${HOSTING_URL}/works` };
    if (base === "/class")
        return { ...common, title: "목공 수업 | OURORA STUDIO", description: "오로라공방의 목공 수업을 소개합니다. 정규 과정, OURORA 8 등 체계적인 목공 프로그램으로 가구 제작을 배워보세요.", url: `${HOSTING_URL}/class` };
    if (base === "/class/regular")
        return { ...common, title: "정규 과정 | OURORA STUDIO", description: "목공의 기초부터 심화까지, 체계적인 커리큘럼으로 진행되는 오로라공방 정규 목공 과정입니다.", url: `${HOSTING_URL}/class/regular` };
    if (base === "/class/ourora8")
        return { ...common, title: "OURORA 8 | OURORA STUDIO", description: "8주 완성 집중 프로그램 OURORA 8. 짧은 기간에 가구 제작의 핵심을 익힐 수 있습니다.", url: `${HOSTING_URL}/class/ourora8` };
    if (base === "/membership")
        return { ...common, title: "멤버십 | OURORA STUDIO", description: "오로라공방 멤버십으로 공방을 자유롭게 이용하세요. 자유반, 연구반 등 다양한 멤버십 혜택을 안내합니다.", url: `${HOSTING_URL}/membership` };
    if (base === "/contact")
        return { ...common, title: "문의하기 | OURORA STUDIO", description: "오로라공방에 목공 수업, 가구 제작, 공방 이용에 관해 문의하세요. 서울 목동 위치.", url: `${HOSTING_URL}/contact` };
    return {
        ...common,
        title: "가구공방 오로라공방 | OURORA STUDIO",
        description: "서울 목동에서 가구 제작 및 목공예를 하는 가구공방 오로라공방(OURORA STUDIO)입니다. 가구를 디자인하고 만듭니다. 그리고 목공의 즐거움을 배울 수 있는 다양한 목공수업도 진행하고 있습니다.",
        url: HOSTING_URL,
    };
}
function postIdFromPath(path) {
    const base = path.split("?")[0];
    const match = base.match(/^\/post\/([^/]+)$/);
    return match?.[1] ?? null;
}
function parseString(value) {
    return typeof value === "string" && value.trim().length > 0 ? value : null;
}
function pickFirstString(values) {
    if (!Array.isArray(values))
        return null;
    for (const value of values) {
        const str = parseString(value);
        if (str)
            return str;
    }
    return null;
}
async function getOgMetaForRequest(path) {
    const postId = postIdFromPath(path);
    if (!postId) {
        return { meta: getOgMetaForPath(path), source: "route-default", postId: null };
    }
    try {
        const snap = await db.collection("works").doc(postId).get();
        if (!snap.exists) {
            logger.warn("OG post doc not found", { postId, path });
            return { meta: getOgMetaForPath(path), source: "post-missing", postId };
        }
        const data = snap.data() ?? {};
        const title = parseString(data.title) ?? "OURORA STUDIO";
        const description = parseString(data.description) ?? "OURORA STUDIO";
        const image = pickFirstString(data.lightImageUrls) ??
            pickFirstString(data.imageUrls) ??
            DEFAULT_OG_IMAGE;
        logger.info("OG post meta resolved", {
            postId,
            path,
            title: truncate(title, 120),
            descriptionLength: description.length,
            image: truncate(image, 200),
        });
        return {
            meta: {
                title,
                description,
                image,
                url: `${HOSTING_URL}/post/${postId}`,
                type: "article",
            },
            source: "post",
            postId,
        };
    }
    catch (error) {
        logger.error("Failed to resolve OG metadata for post", { postId, error: getErrorMessage(error) });
        return { meta: getOgMetaForPath(path), source: "post-error", postId };
    }
}
function buildCrawlerHtml(meta) {
    const e = (s) => s.replace(/&/g, "&amp;").replace(/"/g, "&quot;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
    return `<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>${e(meta.title)}</title>
  <meta name="description" content="${e(meta.description)}" />
  <meta property="og:locale" content="ko" />
  <meta property="og:type" content="${e(meta.type)}" />
  <meta property="og:url" content="${e(meta.url)}" />
  <meta property="og:title" content="${e(meta.title)}" />
  <meta property="og:description" content="${e(meta.description)}" />
  <meta property="og:image" content="${e(meta.image)}" />
</head>
<body><p>${e(meta.description)}</p></body>
</html>`;
}
function escapeHtml(value) {
    return value
        .replace(/&/g, "&amp;")
        .replace(/"/g, "&quot;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;");
}
function applyOrInsertMetaTag(html, selector, tag) {
    if (selector.test(html)) {
        return html.replace(selector, tag);
    }
    return html.replace("</head>", `  ${tag}\n</head>`);
}
function applyMetaToIndexHtml(indexHtml, meta) {
    let html = indexHtml;
    const titleTag = `<title>${escapeHtml(meta.title)}</title>`;
    if (/<title>[\s\S]*?<\/title>/i.test(html)) {
        html = html.replace(/<title>[\s\S]*?<\/title>/i, titleTag);
    }
    else {
        html = html.replace("</head>", `  ${titleTag}\n</head>`);
    }
    html = applyOrInsertMetaTag(html, /<meta[^>]+name=["']description["'][^>]*>/i, `<meta name="description" content="${escapeHtml(meta.description)}" />`);
    html = applyOrInsertMetaTag(html, /<meta[^>]+property=["']og:type["'][^>]*>/i, `<meta property="og:type" content="${escapeHtml(meta.type)}" />`);
    html = applyOrInsertMetaTag(html, /<meta[^>]+property=["']og:url["'][^>]*>/i, `<meta property="og:url" content="${escapeHtml(meta.url)}" />`);
    html = applyOrInsertMetaTag(html, /<meta[^>]+property=["']og:title["'][^>]*>/i, `<meta property="og:title" content="${escapeHtml(meta.title)}" />`);
    html = applyOrInsertMetaTag(html, /<meta[^>]+property=["']og:description["'][^>]*>/i, `<meta property="og:description" content="${escapeHtml(meta.description)}" />`);
    html = applyOrInsertMetaTag(html, /<meta[^>]+property=["']og:image["'][^>]*>/i, `<meta property="og:image" content="${escapeHtml(meta.image)}" />`);
    return html;
}
function parsePathname(value) {
    const trimmed = value.trim();
    if (!trimmed)
        return null;
    try {
        if (trimmed.startsWith("http://") || trimmed.startsWith("https://")) {
            return new URL(trimmed).pathname || "/";
        }
    }
    catch {
        // ignore URL parse error and continue
    }
    const noQuery = trimmed.split("?")[0];
    if (!noQuery.startsWith("/"))
        return `/${noQuery}`;
    return noQuery || "/";
}
function getFirstHeaderValue(value) {
    if (!value)
        return null;
    if (Array.isArray(value))
        return value[0] ?? null;
    return value;
}
function resolveRequestPath(req) {
    const candidates = [
        req.path,
        req.originalUrl,
        req.url,
        getFirstHeaderValue(req.headers["x-original-url"]),
        getFirstHeaderValue(req.headers["x-forwarded-uri"]),
        getFirstHeaderValue(req.headers["x-rewrite-url"]),
    ];
    for (const candidate of candidates) {
        if (!candidate)
            continue;
        const parsed = parsePathname(candidate);
        if (parsed)
            return parsed;
    }
    return "/";
}
let cachedIndexHtml = null;
let indexHtmlCachedAt = 0;
const INDEX_HTML_TTL_MS = 5 * 60 * 1000;
async function getIndexHtml() {
    if (cachedIndexHtml && Date.now() - indexHtmlCachedAt < INDEX_HTML_TTL_MS) {
        return cachedIndexHtml;
    }
    const fetchUrl = `${HOSTING_FETCH_URL}/index.html`;
    const res = await fetch(fetchUrl);
    if (!res.ok) {
        throw new Error(`Failed to fetch index.html from ${fetchUrl}: ${res.status} ${res.statusText}`);
    }
    cachedIndexHtml = await res.text();
    indexHtmlCachedAt = Date.now();
    return cachedIndexHtml;
}
exports.ogRender = (0, https_1.onRequest)({ region: "asia-northeast3" }, async (req, res) => {
    const uaHeader = req.headers["user-agent"];
    const ua = Array.isArray(uaHeader) ? uaHeader.join(" ") : uaHeader ?? "";
    const requestPath = resolveRequestPath(req);
    const og = await getOgMetaForRequest(requestPath);
    const meta = og.meta;
    logger.info("ogRender request classified", {
        path: requestPath,
        reqPath: req.path,
        reqOriginalUrl: req.originalUrl,
        reqUrl: req.url,
        metaSource: og.source,
        postId: og.postId,
        ua: truncate(ua, 300),
    });
    res.set("X-OG-Meta-Source", og.source);
    if (og.postId)
        res.set("X-OG-Post-Id", og.postId);
    try {
        const html = applyMetaToIndexHtml(await getIndexHtml(), meta);
        res.set("X-OG-Render-Mode", "index-with-dynamic-og");
        res.set("Content-Type", "text/html; charset=utf-8");
        res.set("Cache-Control", "no-store");
        res.send(html);
    }
    catch (err) {
        logger.error("Failed to fetch index.html", {
            error: getErrorMessage(err),
            stack: err instanceof Error ? err.stack : null,
        });
        res.set("X-OG-Render-Mode", "fallback-crawler-html");
        res.set("Content-Type", "text/html; charset=utf-8");
        res.set("Cache-Control", "no-store");
        res.status(200).send(buildCrawlerHtml(meta));
    }
});
//# sourceMappingURL=index.js.map