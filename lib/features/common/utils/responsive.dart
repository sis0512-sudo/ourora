// 반응형 레이아웃을 위한 유틸리티 클래스.
// 현재 기기가 모바일인지 판단하고, 그에 따른 그리드 열 수 등을 반환합니다.
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// JavaScript의 navigator.userAgent 값을 Dart에서 읽기 위한 외부(JS) 바인딩
@JS('navigator.userAgent')
external String get _jsUserAgent;

class Responsive {
  // 현재 기기가 모바일(스마트폰/태블릿)인지 여부를 반환합니다.
  // 디버그 모드에서는 브라우저의 User-Agent 문자열로 판단합니다.
  // 릴리즈 모드에서는 Flutter의 플랫폼 정보를 사용합니다.
  static bool get isMobileDevice {
    if (kDebugMode) {
      final ua = _jsUserAgent.toLowerCase();
      return ua.contains('mobile') || ua.contains('android') || ua.contains('iphone') || ua.contains('ipad');
    }
    return defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
  }

  // 그리드(이미지 목록 등)에서 사용할 열(column) 수를 반환합니다.
  // 모바일: 1열, 데스크톱: 3열
  static int gridColumns(BuildContext context) {
    if (isMobileDevice) return 1;
    return 3;
  }
}
