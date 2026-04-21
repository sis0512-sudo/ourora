import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';

enum FeatureCard {
  workshop(assetPath: 'assets/svgs/icon_workshop.svg', title: 'WORKSHOP', subtitle: '공방 소개', desc: '공방에 대한 소개와 문화, 그리고 추구하는 목표와 방향을 이야기합니다.', route: '/about'),
  works(assetPath: 'assets/svgs/icon_works.svg', title: 'WORKS', subtitle: '작품과 작업들', desc: '오로라공방 구성원분들이 제작한 작품들과 작업들을 소개합니다.', route: '/works'),
  cls(assetPath: 'assets/svgs/icon_class.svg', title: 'CLASS', subtitle: '다양한 목공 수업', desc: '가구 디자인 및 목공 기술을 배울 수 있는 전문적인 수업에 참여하실 수 있습니다.', route: '/class'),
  membership(
    assetPath: 'assets/svgs/icon_membership.svg',
    title: 'MEMBERSHIP',
    subtitle: '공방 자유이용',
    desc: '개인 작품활동, 지속적인 취미목공 등을 위해 공방을 자유롭게 이용할 수 있습니다.',
    route: '/membership',
  );

  const FeatureCard({required this.assetPath, required this.title, required this.subtitle, required this.desc, required this.route});

  final String assetPath;
  final String title;
  final String subtitle;
  final String desc;
  final String route;
}

class FeatureCardsSection extends StatelessWidget {
  const FeatureCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: SizedBox(
            height: 450,
            child: Row(
              children: FeatureCard.values.map((card) {
                return SizedBox(width: 245, child: _FeatureCardWidget(card: card));
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureCardWidget extends StatelessWidget {
  final FeatureCard card;

  const _FeatureCardWidget({required this.card});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(card.assetPath, height: 90, colorFilter: const ColorFilter.mode(AppTheme.black, BlendMode.srcIn)),
          const SizedBox(height: 36),
          Text(card.title, style: AppTheme.mainSectionTitle()),
          const SizedBox(height: 24),
          Text(card.subtitle, style: AppTheme.bodyKorean()),
          const SizedBox(height: 24),
          Text(
            card.desc,
            style: GoogleFonts.nanumGothic(fontSize: 14, color: AppTheme.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 158,
            height: 35,
            child: TextButton(
              style: TextButton.styleFrom(backgroundColor: AppTheme.transparent, padding: EdgeInsets.zero),
              onPressed: () => context.go(card.route),
              child: Text('Read More >', style: AppTheme.navItem().copyWith(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
