// HTML의 <meta> 태그를 동적으로 업데이트하는 함수들을 모아둔 파일.
// Flutter Web에서는 index.html의 <head>에 있는 메타 태그를 직접 수정하여
// SNS 공유 미리보기 정보를 페이지별로 다르게 표시합니다.
import 'package:web/web.dart' as web;

import 'og_meta.dart';

// 일반 페이지 이동 시 경로(path)에 맞는 OG 메타 태그를 업데이트합니다.
// router.dart의 redirect 콜백에서 호출됩니다.
void updateOgMeta(String path) {
  final meta = ogMetaForPath(path);
  _applyOgMeta(meta);
}

// 작품 상세 페이지(/post/:id) 진입 시 해당 작품의 OG 메타 태그를 업데이트합니다.
void updateOgMetaForPost({
  required String id,
  required String title,
  required String description,
  String? image,
}) {
  final meta = ogMetaForPost(
    id: id,
    title: title,
    description: description,
    image: image,
  );
  _applyOgMeta(meta);
}

// OgMeta 객체의 값을 실제 HTML <meta> 태그에 적용합니다.
void _applyOgMeta(OgMeta meta) {
  web.document.title = meta.title; // 브라우저 탭 제목 변경
  _setMeta('description', meta.description, isProperty: false);
  _setMeta('og:type', meta.type);
  _setMeta('og:title', meta.title);
  _setMeta('og:description', meta.description);
  _setMeta('og:url', meta.url);
  _setMeta('og:image', meta.image);
}

// 특정 <meta> 태그의 content 값을 설정합니다.
// 태그가 이미 존재하면 content만 수정하고, 없으면 새로 생성하여 <head>에 추가합니다.
// [isProperty]: true → property 속성 사용 (og:title 등), false → name 속성 사용 (description 등)
void _setMeta(String name, String content, {bool isProperty = true}) {
  final attr = isProperty ? 'property' : 'name';
  final selector = 'meta[$attr="$name"]';
  final head = web.document.head;
  if (head == null) return;

  final existing = head.querySelector(selector);
  if (existing != null) {
    // 기존 태그가 있으면 content 값만 교체
    (existing as web.HTMLMetaElement).content = content;
  } else {
    // 없으면 새 <meta> 엘리먼트를 생성하여 <head>에 추가
    final el = web.document.createElement('meta') as web.HTMLMetaElement;
    el.setAttribute(attr, name);
    el.content = content;
    head.append(el);
  }
}
