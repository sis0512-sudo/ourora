// 홈 화면의 F·I·D·P 섹션. 오로라공방의 4가지 핵심 가치를 소개합니다.
// Furniture / IT Convergence / Design / People 4개 항목을 표시합니다.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/about/presentation/screens/fidp_screen.dart';
import 'package:ourora/features/common/utils/constants.dart';
import 'package:ourora/features/common/utils/responsive.dart';

class FidSection extends StatefulWidget {
  const FidSection({super.key});

  @override
  State<FidSection> createState() => _FidSectionState();
}

class _FidSectionState extends State<FidSection> {
  // F·I·D·P 각 항목의 데이터 (알파벳, 제목, 설명)
  List<Map<String, String>> fidItems = [
    {'letter': 'F', 'title': 'FURNITURE', 'desc': '나무로 가구를 만드는 가구공방입니다. 물론 다른 것들도 만듭니다.'},
    {'letter': 'I', 'title': 'IT CONVERGENCE', 'desc': '가구와 IT 기술과의 융합을 통한 새로운 디자인 가능성을 모색합니다.'},
    {'letter': 'D', 'title': 'DESIGN', 'desc': '디자인에 대한 폭넓은 이해와 깊이로 진정성있는 디자인을 고민합니다.'},
    {'letter': 'P', 'title': 'PEOPLE', 'desc': '누구나 참여할 수 있는 다양한 가구제작 수업과 워크숍이 있습니다.'},
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return Container(
      color: AppTheme.white,
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: AppConstants.windowMaxWidth),
          child: Column(
            children: [
              // 섹션 타이틀
              Text(
                '오로라 공방은?',
                style: TextStyle(fontFamily: 'BMHanna', fontSize: isMobile ? 28 : 20, fontWeight: FontWeight.w700, letterSpacing: 4, color: AppTheme.darkBg),
              ),
              const SizedBox(height: 12),
              // 제목 아래 구분선
              Container(
                width: isMobile ? 60 : 40,
                height: 3,
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppTheme.darkBg, width: 3)),
                ),
              ),
              const SizedBox(height: 48),
              // 모바일: Column, 데스크톱: Row 배치
              isMobile
                  ? Column(
                      children: fidItems.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: _FidItem(letter: item['letter']!, title: item['title']!, desc: item['desc']!),
                        );
                      }).toList(),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: fidItems.map((item) {
                        return SizedBox(
                          width: 245,
                          child: _FidItem(letter: item['letter']!, title: item['title']!, desc: item['desc']!),
                        );
                      }).toList(),
                    ),
              const SizedBox(height: 48),
              // 'Read More >>' 버튼: FIDP 상세 페이지로 이동
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.black),
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 50 : 40, vertical: isMobile ? 20 : 16),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  overlayColor: AppTheme.transparent,
                  surfaceTintColor: AppTheme.transparent,
                ),
                onPressed: () => context.go(FIDPScreen.route),
                child: Text('Read More >>', style: AppTheme.navItem(isMobile)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// F·I·D·P 항목 하나를 표시하는 위젯: 큰 알파벳 → 소제목 → 설명 순서로 배치됩니다.
class _FidItem extends StatelessWidget {
  final String letter; // 'F', 'I', 'D', 'P' 중 하나
  final String title;  // 영문 제목 (예: 'FURNITURE')
  final String desc;   // 한글 설명

  const _FidItem({required this.letter, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return Padding(
      padding: isMobile ? EdgeInsets.symmetric(horizontal: 40) : EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // ArialBlack 폰트의 큰 알파벳 문자 (F/I/D/P)
          Text(
            letter,
            style: TextStyle(fontFamily: 'ArialBlack', fontSize: isMobile ? 80 : 70, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.notoSansKr(fontSize: isMobile ? 24 : 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            desc,
            style: GoogleFonts.notoSansKr(fontSize: isMobile ? 20 : 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
