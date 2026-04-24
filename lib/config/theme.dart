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

  static TextStyle navItem(bool isMobile) =>
      TextStyle(fontFamily: 'Raleway', fontSize: isMobile ? 20 : 16, fontWeight: FontWeight.w600, letterSpacing: 1.5, color: black);
  static TextStyle mainSectionTitle(bool isMobile) =>
      GoogleFonts.montserrat(fontSize: isMobile ? 24 : 18, fontWeight: FontWeight.w800, letterSpacing: 3, color: black);
  static TextStyle bodyKorean(bool isMobile) => GoogleFonts.notoSansKr(fontSize: isMobile ? 20 : 16, fontWeight: FontWeight.w400, color: black);
  static TextStyle pageTitle(bool isMobile) => TextStyle(fontFamily: 'BMHanna', fontSize: isMobile ? 32 : 28, color: black, letterSpacing: 4);
  static TextStyle contactBody() => GoogleFonts.notoSansKr(fontSize: 20, fontWeight: FontWeight.w400, height: 1.5, color: black);

  static ThemeData get themeData => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: white,
    colorScheme: ColorScheme.fromSeed(seedColor: black),
    fontFamily: GoogleFonts.notoSansKr().fontFamily,
    fontFamilyFallback: const ['Apple SD Gothic Neo', 'Malgun Gothic', 'sans-serif'],
  );
}
