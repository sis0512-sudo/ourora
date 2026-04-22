import 'package:web/web.dart' as web;

import 'og_meta.dart';

void updateOgMeta(String path) {
  final meta = ogMetaForPath(path);
  _applyOgMeta(meta);
}

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

void _applyOgMeta(OgMeta meta) {
  web.document.title = meta.title;
  _setMeta('description', meta.description, isProperty: false);
  _setMeta('og:type', meta.type);
  _setMeta('og:title', meta.title);
  _setMeta('og:description', meta.description);
  _setMeta('og:url', meta.url);
  _setMeta('og:image', meta.image);
}

void _setMeta(String name, String content, {bool isProperty = true}) {
  final attr = isProperty ? 'property' : 'name';
  final selector = 'meta[$attr="$name"]';
  final head = web.document.head;
  if (head == null) return;

  final existing = head.querySelector(selector);
  if (existing != null) {
    (existing as web.HTMLMetaElement).content = content;
  } else {
    final el = web.document.createElement('meta') as web.HTMLMetaElement;
    el.setAttribute(attr, name);
    el.content = content;
    head.append(el);
  }
}
