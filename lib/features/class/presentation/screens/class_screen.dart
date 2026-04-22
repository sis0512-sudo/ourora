import 'package:flutter/material.dart';
import 'package:ourora/features/class/presentation/widgets/class/class_common_guidelines_section.dart';
import 'package:ourora/features/class/presentation/widgets/class/class_course_cards_section.dart';
import 'package:ourora/features/class/presentation/widgets/class/class_environment_section.dart';
import 'package:ourora/features/class/presentation/widgets/class/class_header_section.dart';
import 'package:ourora/features/common/presentation/widgets/nav_bar.dart';
import 'package:ourora/features/common/presentation/widgets/screen_content_sliver.dart';
import 'package:ourora/features/common/presentation/widgets/site_footer.dart';

class ClassScreen extends StatelessWidget {
  static const String route = '/class';

  const ClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(delegate: NavBarDelegate(), pinned: true),
          ScreenContentSliver(
            child: const Column(
              children: [ClassHeaderSection(), ClassCourseCardsSection(), ClassCommonGuidelinesSection(), ClassEnvironmentSection(), SizedBox(height: 80)],
            ),
          ),
          const SliverToBoxAdapter(child: SiteFooter()),
        ],
      ),
    );
  }
}
