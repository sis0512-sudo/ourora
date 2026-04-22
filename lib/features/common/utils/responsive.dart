import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@JS('navigator.userAgent')
external String get _jsUserAgent;

class Responsive {
  static bool get isMobileDevice {
    if (kDebugMode) {
      final ua = _jsUserAgent.toLowerCase();
      return ua.contains('mobile') || ua.contains('android') || ua.contains('iphone') || ua.contains('ipad');
    }
    return defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
  }

  static int gridColumns(BuildContext context) {
    if (isMobileDevice) return 1;
    return 3;
  }

  static int featureColumns(BuildContext context) {
    if (isMobileDevice) return 1;
    return 4;
  }
}
