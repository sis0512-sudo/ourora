import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourora/features/common/presentation/widgets/nav_bar.dart';
import 'package:ourora/features/common/presentation/widgets/screen_content_sliver.dart';
import 'package:ourora/features/common/presentation/widgets/site_footer.dart';
import 'package:ourora/features/works/application/works_controller.dart';
import 'package:ourora/features/works/presentation/widgets/works_grid_section.dart';

class WorksScreen extends ConsumerWidget {
  static const String route = '/works';

  const WorksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          final metrics = notification.metrics;
          if (metrics.pixels >= metrics.maxScrollExtent - 400) {
            ref.read(worksControllerProvider.notifier).loadMore();
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(delegate: NavBarDelegate(), pinned: true),
            ScreenContentSliver(child: const Column(children: [WorksGridSection(), SizedBox(height: 80)])),
            const SliverToBoxAdapter(child: SiteFooter()),
          ],
        ),
      ),
    );
  }
}
