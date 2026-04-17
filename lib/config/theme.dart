import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 색상
  static const Color black = Color(0xFF111111);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF7F7F7);
  static const Color textGray = Color(0xFF555555);
  static const Color borderGray = Color(0xFFDDDDDD);
  static const Color darkBg = Color(0xFF2F2E2E);
  static const Color accentOrange = Color(0xFFF28241);

  // 타이포그래피
  static TextStyle navItem() => GoogleFonts.raleway(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        color: black,
      );

  static TextStyle heroSubtitle() => const TextStyle(
        fontFamily: 'Arial',
        fontSize: 26,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      );

  static TextStyle heroTitle() => const TextStyle(
        fontFamily: 'Arial',
        fontSize: 60,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        height: 1.1,
      );

  static TextStyle sectionTitle() => GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        letterSpacing: 3,
        color: black,
      );

  static TextStyle bodyKorean() => GoogleFonts.notoSansKr(
        fontSize: 14,
        height: 1.8,
        color: textGray,
      );

  static TextStyle footerCtaTitle() => const TextStyle(
        fontFamily: 'Arial',
        fontSize: 70,
        fontWeight: FontWeight.w900,
        color: Colors.white,
        letterSpacing: 4,
      );

  static TextStyle footerCtaSubtitle() => const TextStyle(
        fontFamily: 'Arial',
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: Colors.white,
        letterSpacing: 3,
      );

  static ThemeData get themeData => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: white,
        colorScheme: ColorScheme.fromSeed(seedColor: black),
        fontFamily: 'NotoSansKR',
      );
}
