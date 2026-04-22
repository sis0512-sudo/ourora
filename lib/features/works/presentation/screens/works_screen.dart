import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ourora/features/common/presentation/widgets/nav_bar.dart';
import 'package:ourora/features/common/presentation/widgets/site_footer.dart';
import 'package:ourora/features/works/presentation/widgets/works_grid_section.dart';
import 'package:ourora/features/works/presentation/widgets/works_upload_section.dart';

class WorksScreen extends StatelessWidget {
  static const String route = '/works';

  const WorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(delegate: NavBarDelegate(), pinned: true),
          if (kDebugMode) const SliverToBoxAdapter(child: WorksUploadSection()),
          const SliverToBoxAdapter(child: WorksGridSection()),
          const SliverToBoxAdapter(child: SiteFooter()),
        ],
      ),
    );
  }
}
