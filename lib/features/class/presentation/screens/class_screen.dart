import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/class/presentation/widgets/class_common_guidelines_section.dart';
import 'package:ourora/features/class/presentation/widgets/class_course_cards_section.dart';
import 'package:ourora/features/class/presentation/widgets/class_environment_section.dart';
import 'package:ourora/features/class/presentation/widgets/class_header_section.dart';
import 'package:ourora/features/common/presentation/widgets/nav_bar.dart';
import 'package:ourora/features/common/presentation/widgets/site_footer.dart';
import 'package:ourora/features/common/utils/constants.dart';

class ClassScreen extends StatelessWidget {
  const ClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(delegate: NavBarDelegate(), pinned: true),
          SliverToBoxAdapter(
            child: Container(
              color: AppTheme.white,
              width: double.infinity,
              padding: AppConstants.horizontalPadding,
              child: const Column(children: [ClassHeaderSection(), ClassCourseCardsSection(), ClassCommonGuidelinesSection(), ClassEnvironmentSection()]),
            ),
          ),

          const SliverToBoxAdapter(child: SiteFooter()),
        ],
      ),
    );
  }
}
