import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 색상
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF7F7F7);
  static const Color textGray = Color(0xFF555555);
  static const Color lineGray = Color(0xFF3A3A3A);
  static const Color borderGray = Color(0xFFDDDDDD);
  static const Color darkBg = Color(0xFF2F2E2E);
  static const Color accentOrange = Color(0xFFF28241);
  static const Color red = Color(0xFFF80000);
  static const Color coral = Color(0xFFFF6161);
  static const Color rosewood = Color(0xFFB08484);
  static const Color transparent = Color(0x00000000);

  // 타이포그래피 — 공통
  static TextStyle navItem() => const TextStyle(fontFamily: 'Raleway', fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1.5, color: black);
  static TextStyle mainSectionTitle() => GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 3, color: black);
  static TextStyle bodyKorean() => GoogleFonts.nanumGothic(fontSize: 16, fontWeight: FontWeight.w400, color: black);
  static TextStyle pageTitle() => const TextStyle(fontFamily: 'BMHanna', fontSize: 28, color: black, letterSpacing: 4);

  // Site Footer
  static TextStyle footerText() => const TextStyle(fontFamily: 'Roboto', fontSize: 14, height: 1.5, fontWeight: FontWeight.w100, color: textGray);

  // About — Brand 섹션
  static TextStyle brandTitle() => GoogleFonts.montserrat(fontSize: 34, fontWeight: FontWeight.w900, color: white);
  static TextStyle brandBodyText() => GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w400, color: white, height: 2.0);

  // About — Profile 섹션
  static TextStyle profileText() => TextStyle(fontFamily: 'Noto Sans KR', fontSize: 14, height: 2.5, letterSpacing: 0.14, color: white.withValues(alpha: 0.5));

  // Contact
  static TextStyle contactBody() => GoogleFonts.nanumMyeongjo(fontSize: 20, fontWeight: FontWeight.w400, height: 1.5, color: black);

  static ThemeData get themeData => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: white,
    colorScheme: ColorScheme.fromSeed(seedColor: black),
    fontFamily: 'NotoSansKR',
  );
}
