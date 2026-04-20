import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

const _mapSrc = 'https://maps.google.com/maps?q=%EC%98%A4%EB%A1%9C%EB%9D%BC%EA%B3%B5%EB%B0%A9&ll=37.5254457,126.8631417&z=14&output=embed';
const kContactMapViewType = 'ourora-google-maps';

bool _mapRegistered = false;

void registerContactMapView() {
  if (_mapRegistered) return;
  _mapRegistered = true;
  ui_web.platformViewRegistry.registerViewFactory(kContactMapViewType, (int viewId) {
    final iframe = web.document.createElement('iframe') as web.HTMLIFrameElement;
    iframe.src = _mapSrc;
    iframe.style.border = 'none';
    iframe.style.width = '100%';
    iframe.style.height = '100%';
    iframe.allowFullscreen = true;
    iframe.setAttribute('loading', 'eager');
    iframe.setAttribute('fetchpriority', 'high');
    return iframe;
  });
}

class ContactMapView extends StatelessWidget {
  const ContactMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return const HtmlElementView(viewType: kContactMapViewType);
  }
}
