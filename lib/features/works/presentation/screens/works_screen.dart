// 작품 갤러리 화면(/works).
// 무한 스크롤로 작품 그리드를 표시합니다.
// 스크롤이 하단에서 400px 이내에 도달하면 자동으로 다음 페이지를 로드합니다.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/nav_bar.dart';
import 'package:ourora/features/common/presentation/widgets/screen_content_sliver.dart';
import 'package:ourora/features/common/presentation/widgets/site_footer.dart';
import 'package:ourora/features/works/application/works_controller.dart';
import 'package:ourora/features/works/presentation/widgets/works_grid_section.dart';

class WorksScreen extends ConsumerWidget {
  static const String route = '/works'; // go_router URL 경로

  const WorksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.black,
      body: NotificationListener<ScrollNotification>(
        // 스크롤 이벤트를 감지하여 하단 근처에서 추가 데이터를 로드합니다.
        onNotification: (notification) {
          final metrics = notification.metrics;
          // 스크롤 위치가 최대 스크롤 범위 - 400px 이하가 되면 loadMore 호출
          if (metrics.pixels >= metrics.maxScrollExtent - 400) {
            ref.read(worksControllerProvider.notifier).loadMore();
          }
          return false; // false 반환: 이벤트를 부모에게도 전달
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
