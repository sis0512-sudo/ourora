import 'package:flutter/material.dart';

class AppTheme {
  // 색상
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF7F7F7);
  static const Color textGray = Color(0xFF555555);
  static const Color borderGray = Color(0xFFDDDDDD);
  static const Color darkBg = Color(0xFF2F2E2E);
  static const Color accentOrange = Color(0xFFF28241);
  static const Color red = Color(0xFFF80000);

  // 타이포그래피
  static TextStyle navItem() => const TextStyle(fontFamily: 'Raleway', fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1.5, color: black);

  static TextStyle heroSubtitle() =>
      const TextStyle(fontFamily: 'Playfair', fontSize: 26, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500, color: white);

  static TextStyle heroTitle() => const TextStyle(fontFamily: 'Raleway', fontSize: 60, fontWeight: FontWeight.w700, color: white, height: 1.1);

  static TextStyle sectionTitle() =>
      const TextStyle(fontFamily: 'Montserrat ExtraBold', fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 3, color: black);

  static TextStyle bodyKorean() => const TextStyle(fontFamily: 'NanumGothic', fontSize: 16, height: 1.8, color: black);

  static TextStyle bodyKoreanSmall() => const TextStyle(fontFamily: 'NanumGothic', fontSize: 14, height: 1.8, color: black);

  static TextStyle footerCtaTitle() => const TextStyle(fontFamily: 'Arial', fontSize: 70, fontWeight: FontWeight.w900, color: white, letterSpacing: 4);

  static TextStyle footerCtaSubtitle() => const TextStyle(fontFamily: 'Arial', fontSize: 24, fontWeight: FontWeight.w400, color: white, letterSpacing: 3);

  static ThemeData get themeData => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: white,
    colorScheme: ColorScheme.fromSeed(seedColor: black),
    fontFamily: 'NotoSansKR',
  );
}
