// 홈 화면에서 WORKSHOP / WORKS / CLASS / MEMBERSHIP 4개의 기능 카드를 표시하는 섹션.
// 각 카드는 아이콘·제목·설명·'Read More' 버튼으로 구성되며 해당 페이지로 이동합니다.
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/constants.dart';
import 'package:ourora/features/common/utils/responsive.dart';

// 각 기능 카드의 데이터를 열거형(enum)으로 정의합니다.
// 열거형을 사용하면 카드 데이터와 순서가 한 곳에서 관리됩니다.
enum FeatureCard {
  workshop(
    assetPath: 'assets/svgs/icon_workshop.svg',
    title: 'WORKSHOP',
    subtitle: '공방 소개',
    desc: '공방에 대한 소개와 문화, 그리고 추구하는 목표와 방향을 이야기합니다.',
    route: '/about',
  ),
  works(
    assetPath: 'assets/svgs/icon_works.svg',
    title: 'WORKS',
    subtitle: '작품과 작업들',
    desc: '오로라공방 구성원분들이 제작한 작품들과 작업들을 소개합니다.',
    route: '/works',
  ),
  cls(
    assetPath: 'assets/svgs/icon_class.svg',
    title: 'CLASS',
    subtitle: '다양한 목공 수업',
    desc: '가구 디자인 및 목공 기술을 배울 수 있는 전문적인 수업에 참여하실 수 있습니다.',
    route: '/class',
  ),
  membership(
    assetPath: 'assets/svgs/icon_membership.svg',
    title: 'MEMBERSHIP',
    subtitle: '공방 자유이용',
    desc: '개인 작품활동, 지속적인 취미목공 등을 위해 공방을 자유롭게 이용할 수 있습니다.',
    route: '/membership',
  );

  const FeatureCard({
    required this.assetPath,
    required this.title,
    required this.subtitle,
    required this.desc,
    required this.route,
  });

  final String assetPath; // SVG 아이콘 파일 경로
  final String title;     // 영문 제목 (예: 'WORKS')
  final String subtitle;  // 한글 부제목 (예: '작품과 작업들')
  final String desc;      // 카드 설명 문자열
  final String route;     // 클릭 시 이동할 URL 경로
}

// 4개의 기능 카드를 배치하는 섹션 위젯.
// 모바일: 세로 Column 배치, 데스크톱: 가로 Row 배치
class FeatureCardsSection extends StatelessWidget {
  const FeatureCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return Container(
      color: AppTheme.white,
      child: isMobile
          ? Padding(
              padding: const EdgeInsets.all(60),
              child: Column(
                children: FeatureCard.values.map((card) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _FeatureCardWidget(card: card),
                  );
                }).toList(),
              ),
            )
          : Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: AppConstants.windowMaxWidth,
                ),
                child: SizedBox(
                  height: 450,
                  child: Row(
                    children: FeatureCard.values.map((card) {
                      return SizedBox(
                        width: 245,
                        child: _FeatureCardWidget(card: card),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
    );
  }
}

// 기능 카드 하나를 표시하는 위젯: 아이콘 → 제목 → 부제목 → 설명 → 버튼 순서로 배치됩니다.
class _FeatureCardWidget extends StatelessWidget {
  final FeatureCard card;

  const _FeatureCardWidget({required this.card});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 0 : 32,
        vertical: isMobile ? 20 : 0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SVG 아이콘 (AppTheme.black으로 색상 변경)
          SvgPicture.asset(
            card.assetPath,
            height: isMobile ? 120 : 90,
            colorFilter: const ColorFilter.mode(
              AppTheme.black,
              BlendMode.srcIn, // SVG의 모든 색상을 black으로 교체
            ),
          ),
          const SizedBox(height: 36),
          Text(card.title, style: AppTheme.mainSectionTitle(isMobile)),
          const SizedBox(height: 24),
          Text(card.subtitle, style: AppTheme.bodyKorean(isMobile)),
          const SizedBox(height: 24),
          Text(
            card.desc,
            style: GoogleFonts.notoSansKr(
              fontSize: isMobile ? 18 : 14,
              color: AppTheme.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // 'Read More >' 버튼 클릭 시 해당 페이지로 이동
          SizedBox(
            width: 158,
            height: 35,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.transparent,
                padding: EdgeInsets.zero,
              ),
              onPressed: () => context.go(card.route),
              child: Text('Read More >', style: AppTheme.navItem(isMobile)),
            ),
          ),
        ],
      ),
    );
  }
}
