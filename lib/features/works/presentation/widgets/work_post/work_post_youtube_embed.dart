// 작품 상세 페이지에 YouTube 영상을 임베드하는 위젯.
// Flutter Web에서는 YouTube 플레이어를 직접 지원하지 않으므로,
// HTML iframe을 platformViewRegistry에 등록하여 Flutter 위젯처럼 사용합니다.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

class WorkPostYoutubeEmbed extends StatefulWidget {
  final String url; // YouTube 영상 URL (일반 URL 또는 단축 URL 모두 지원)

  const WorkPostYoutubeEmbed({super.key, required this.url});

  @override
  State<WorkPostYoutubeEmbed> createState() => _WorkPostYoutubeEmbedState();
}

class _WorkPostYoutubeEmbedState extends State<WorkPostYoutubeEmbed> {
  late final String _viewId; // 이 iframe을 Flutter가 식별할 고유 ID

  @override
  void initState() {
    super.initState();
    // URL의 해시값으로 고유한 viewId를 생성합니다 (같은 영상이 여러 번 등록되지 않도록)
    _viewId = 'youtube-iframe-${widget.url.hashCode}';
    final embedUrl = _toEmbedUrl(widget.url);

    // platformViewRegistry: Flutter Web에서 HTML 엘리먼트를 위젯으로 사용하기 위한 등록소
    // 한 번만 등록하면 되며, HtmlElementView가 이를 렌더링합니다.
    ui_web.platformViewRegistry.registerViewFactory(
      _viewId,
      (int id) => html.IFrameElement()
        ..src = embedUrl
        ..style.border = 'none'
        ..allowFullscreen = true
        ..setAttribute(
          'allow',
          'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture',
        ),
    );
  }

  // 일반 YouTube URL을 임베드 URL로 변환합니다.
  // 예: https://www.youtube.com/watch?v=ABC → https://www.youtube.com/embed/ABC
  // 예: https://youtu.be/ABC → https://www.youtube.com/embed/ABC
  String _toEmbedUrl(String url) {
    // 일반 URL 패턴: ?v=VIDEOID
    final watchMatch = RegExp(r'[?&]v=([^&]+)').firstMatch(url);
    if (watchMatch != null) {
      return 'https://www.youtube.com/embed/${watchMatch.group(1)}';
    }
    // 단축 URL 패턴: youtu.be/VIDEOID
    final shortMatch = RegExp(r'youtu\.be/([^?]+)').firstMatch(url);
    if (shortMatch != null) {
      return 'https://www.youtube.com/embed/${shortMatch.group(1)}';
    }
    return url; // 변환할 수 없으면 원본 URL 그대로 사용
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9, // 표준 와이드스크린 비율 유지
      child: HtmlElementView(viewType: _viewId), // 등록된 iframe을 Flutter 위젯으로 렌더링
    );
  }
}
