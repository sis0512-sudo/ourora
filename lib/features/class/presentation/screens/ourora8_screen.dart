import 'package:flutter/material.dart';
import 'package:ourora/features/class/presentation/widgets/class/class_header.dart';
import 'package:ourora/features/class/presentation/widgets/ourora8/ourora8_content_section.dart';
import 'package:ourora/features/common/presentation/widgets/nav_bar.dart';
import 'package:ourora/features/common/presentation/widgets/screen_content_sliver.dart';
import 'package:ourora/features/common/presentation/widgets/site_footer.dart';
import 'package:ourora/features/common/utils/responsive.dart';

class Ourora8Screen extends StatelessWidget {
  static const String route = '/ourora8';

  const Ourora8Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(delegate: NavBarDelegate(), pinned: true),
          ScreenContentSliver(
            child: Padding(
              padding: isMobile ? const EdgeInsets.symmetric(horizontal: 32) : EdgeInsets.zero,
              child: Column(
                children: [
                  ClassHeader(
                    title: 'OURORA8\n오로라에잇 전문가반 클래스',
                    description: '최고 수준의 목공 기술을 기반으로 다양한 디자인 실험 및 자유로운 작품 창작이 가능한\n가구 디자이너 또는 공예 작가로서의 성장을 추구합니다.\n초보자를 대상으로 합니다.',
                    image: isMobile ? const SizedBox.shrink() : Image.asset('assets/images/ourora8_logo.png', height: 134, fit: BoxFit.contain),
                  ),
                  Ourora8ContentSection(isMobile: isMobile),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SiteFooter()),
        ],
      ),
    );
  }
}
