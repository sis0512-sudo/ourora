// 앱 전체에서 사용하는 색상·텍스트 스타일·테마 데이터를 정의합니다.
// Colors.white 등 Flutter 기본 색상 대신 반드시 AppTheme.* 상수를 사용하세요.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── 색상 상수 ──────────────────────────────────────────────────────────────
  // 앱 전체에서 일관된 색상을 유지하기 위해 상수로 정의합니다.
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF7F7F7);   // 배경·호버 색상
  static const Color textGray = Color(0xFF555555);     // 일반 본문 텍스트
  static const Color lineGray = Color(0xFF3A3A3A);     // 구분선
  static const Color borderGray = Color(0xFFDDDDDD);  // 테두리
  static const Color darkBg = Color(0xFF2F2E2E);       // 어두운 배경 섹션
  static const Color accentOrange = Color(0xFFF28241); // 강조색 (버튼, 링크 등)
  static const Color red = Color(0xFFF80000);          // 에러·경고
  static const Color coral = Color(0xFFFF6161);        // 호버 강조 / 자유반 카드
  static const Color rosewood = Color(0xFFB08484);     // 연구반 카드
  static const Color transparent = Color(0x00000000);  // 완전 투명

  // ── 텍스트 스타일 ──────────────────────────────────────────────────────────
  // isMobile: 모바일 여부에 따라 폰트 크기를 다르게 적용합니다.

  // 상단 네비게이션 메뉴 아이템 스타일 (Raleway 폰트)
  static TextStyle navItem(bool isMobile) =>
      TextStyle(fontFamily: 'Raleway', fontSize: isMobile ? 20 : 16, fontWeight: FontWeight.w600, letterSpacing: 1.5, color: black);

  // 각 섹션의 제목 스타일 (Montserrat 폰트)
  static TextStyle mainSectionTitle(bool isMobile) =>
      GoogleFonts.montserrat(fontSize: isMobile ? 24 : 18, fontWeight: FontWeight.w800, letterSpacing: 3, color: black);

  // 한글 본문 텍스트 스타일 (Noto Sans KR 폰트)
  static TextStyle bodyKorean(bool isMobile) => GoogleFonts.notoSansKr(fontSize: isMobile ? 20 : 16, fontWeight: FontWeight.w400, color: black);

  // 페이지 타이틀 스타일 (BMHanna 에셋 폰트)
  static TextStyle pageTitle(bool isMobile) => TextStyle(fontFamily: 'BMHanna', fontSize: isMobile ? 32 : 28, color: black, letterSpacing: 4);

  // 문의(contact) 페이지 본문 텍스트 스타일
  static TextStyle contactBody() => GoogleFonts.notoSansKr(fontSize: 20, fontWeight: FontWeight.w400, height: 1.5, color: black);

  // ── Material 테마 데이터 ───────────────────────────────────────────────────
  // MaterialApp의 theme 속성에 전달합니다.
  static ThemeData get themeData => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: white,
    colorScheme: ColorScheme.fromSeed(seedColor: black),
    fontFamily: GoogleFonts.notoSansKr().fontFamily, // 기본 폰트: Noto Sans KR
    fontFamilyFallback: const ['Apple SD Gothic Neo', 'Malgun Gothic', 'sans-serif'], // 한글 폴백 폰트
  );
}
