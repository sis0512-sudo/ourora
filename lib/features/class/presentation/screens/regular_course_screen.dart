import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ourora/features/class/presentation/widgets/class/class_header.dart';
import 'package:ourora/features/class/presentation/widgets/regular/regular_course_content_section.dart';
import 'package:ourora/features/common/presentation/widgets/nav_bar.dart';
import 'package:ourora/features/common/presentation/widgets/screen_content_sliver.dart';
import 'package:ourora/features/common/presentation/widgets/site_footer.dart';
import 'package:ourora/features/common/utils/responsive.dart';

class RegularCourseScreen extends StatelessWidget {
  static const String route = '/regular-course';
  const RegularCourseScreen({super.key});

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
                    title: 'REGULAR COURSE\n정규과정',
                    description: '기초부터 차근차근 중급이상의 기술과 디자인 스킬을\n습득할 수 있는 정규과정입니다.',
                    image: isMobile ? const SizedBox.shrink() : SvgPicture.asset('assets/svgs/regular_course.svg', height: 200, fit: BoxFit.contain),
                  ),
                  const RegularCourseContentSection(),
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
