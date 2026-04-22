// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

class WorkPostYoutubeEmbed extends StatefulWidget {
  final String url;

  const WorkPostYoutubeEmbed({super.key, required this.url});

  @override
  State<WorkPostYoutubeEmbed> createState() => _WorkPostYoutubeEmbedState();
}

class _WorkPostYoutubeEmbedState extends State<WorkPostYoutubeEmbed> {
  late final String _viewId;

  @override
  void initState() {
    super.initState();
    _viewId = 'youtube-iframe-${widget.url.hashCode}';
    final embedUrl = _toEmbedUrl(widget.url);
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

  String _toEmbedUrl(String url) {
    final watchMatch = RegExp(r'[?&]v=([^&]+)').firstMatch(url);
    if (watchMatch != null) {
      return 'https://www.youtube.com/embed/${watchMatch.group(1)}';
    }
    final shortMatch = RegExp(r'youtu\.be/([^?]+)').firstMatch(url);
    if (shortMatch != null) {
      return 'https://www.youtube.com/embed/${shortMatch.group(1)}';
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: HtmlElementView(viewType: _viewId),
    );
  }
}
