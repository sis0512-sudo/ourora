import 'package:flutter/material.dart';
import 'package:ourora/features/common/presentation/widgets/nav_bar.dart';
import 'package:ourora/features/common/presentation/widgets/screen_content_sliver.dart';
import 'package:ourora/features/common/presentation/widgets/site_footer.dart';
import 'package:ourora/features/works/presentation/widgets/work_post/work_post_content_section.dart';

class WorkPostScreen extends StatelessWidget {
  static const String routePattern = '/post/:id';

  static String routeFor(String id) => '/post/$id';

  final String workId;

  const WorkPostScreen({super.key, required this.workId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(delegate: NavBarDelegate(), pinned: true),
          ScreenContentSliver(
            child: WorkPostContentSection(workId: workId),
          ),
          const SliverToBoxAdapter(child: SiteFooter()),
        ],
      ),
    );
  }
}
