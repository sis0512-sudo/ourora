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

  // 타이포그래피 — 공통
  static TextStyle navItem() => const TextStyle(fontFamily: 'Raleway', fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1.5, color: black);

  static TextStyle heroSubtitle() =>
      const TextStyle(fontFamily: 'Playfair', fontSize: 26, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500, color: white);

  static TextStyle heroTitle() => const TextStyle(fontFamily: 'Raleway', fontSize: 60, fontWeight: FontWeight.w700, color: white, height: 1.1);

  static TextStyle mainSectionTitle() => GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 3, color: black);

  static TextStyle bodyKorean() => const TextStyle(fontFamily: 'NanumGothic', fontSize: 16, color: black);

  static TextStyle bodyKoreanSmall() => const TextStyle(fontFamily: 'NanumGothic', fontSize: 14, color: black);

  static TextStyle pageTitleCaption() => const TextStyle(fontFamily: 'NanumGothic', fontSize: 15, color: black);
  static TextStyle pageTitle() => const TextStyle(fontFamily: 'BMHanna', fontSize: 28, color: black, letterSpacing: 4);
  static TextStyle pageSubTitle() => const TextStyle(fontFamily: 'BMHanna', fontSize: 24, color: black);

  // Footer CTA
  static TextStyle footerCtaTitle() => const TextStyle(fontFamily: 'Arial Black', fontSize: 70, fontWeight: FontWeight.w900, color: white, letterSpacing: 4);

  static TextStyle footerCtaSubtitle() => const TextStyle(fontFamily: 'Arial', fontSize: 24, fontWeight: FontWeight.w400, color: white, letterSpacing: 3);

  static TextStyle ctaButton() => const TextStyle(fontSize: 16, letterSpacing: 0.5);

  // Site Footer
  static TextStyle footerText() => const TextStyle(fontFamily: 'Roboto', fontSize: 14, height: 1.5, fontWeight: FontWeight.w100, color: textGray);

  // FID 섹션
  static TextStyle fidSectionHeader() => const TextStyle(fontFamily: 'BMHanna', fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: 4, color: darkBg);

  static TextStyle fidLetter() => const TextStyle(fontFamily: 'BMHanna', fontSize: 70, fontWeight: FontWeight.bold, color: black, height: 1);

  static TextStyle fidItemTitle() => const TextStyle(fontFamily: 'Arial', fontSize: 16, fontWeight: FontWeight.bold, color: black, letterSpacing: 1);

  // YouTube 피드
  static TextStyle videoDuration() => const TextStyle(color: white, fontSize: 12, fontWeight: FontWeight.w500);

  static TextStyle videoCardTitle() => const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: black, height: 1.4);

  static TextStyle videoCardDesc() => TextStyle(fontSize: 12, color: textGray.withValues(alpha: 0.8), height: 1.6);

  // Instagram
  static TextStyle loadMoreButton() => const TextStyle(fontFamily: 'Arial', fontSize: 13, color: black);

  // About — Brand 섹션
  static TextStyle brandTitle() => GoogleFonts.montserrat(fontSize: 34, fontWeight: FontWeight.w900, color: white);

  static TextStyle brandBodyText() => GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w400, color: white, height: 2.0);

  // About — Profile 섹션
  static TextStyle chiefHeading() => const TextStyle(fontFamily: 'sans-serif', fontSize: 46, fontWeight: FontWeight.bold, letterSpacing: 11.5, color: textGray);

  static TextStyle profileSubheading() =>
      const TextStyle(fontFamily: 'Noto Sans KR', fontSize: 17, fontWeight: FontWeight.normal, letterSpacing: 4, color: textGray);

  static TextStyle profileSectionTitle() =>
      const TextStyle(fontFamily: 'Noto Sans KR', fontSize: 18, fontWeight: FontWeight.bold, height: 2.5, letterSpacing: 0.14, color: textGray);

  static TextStyle profileText() => const TextStyle(fontFamily: 'Noto Sans KR', fontSize: 14, height: 2.5, letterSpacing: 0.14, color: textGray);

  static TextStyle profileLink() =>
      const TextStyle(fontFamily: 'Noto Sans KR', fontSize: 10, height: 2.5, color: textGray, decoration: TextDecoration.underline);

  // About — FIDP 섹션
  static TextStyle aboutFidpTitle() => const TextStyle(fontFamily: 'sans-serif', fontSize: 36, fontWeight: FontWeight.w300, letterSpacing: 3, color: black);

  static TextStyle fidpButton() => GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1.5);

  // Contact
  static TextStyle contactBody() => GoogleFonts.nanumMyeongjo(fontSize: 20, fontWeight: FontWeight.w400, height: 1.5, color: black);

  static ThemeData get themeData => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: white,
    colorScheme: ColorScheme.fromSeed(seedColor: black),
    fontFamily: 'NotoSansKR',
  );
}
