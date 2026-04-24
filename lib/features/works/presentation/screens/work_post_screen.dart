// 작품 상세 페이지(/post/:id).
// URL의 :id 파라미터로 특정 작품을 로드하여 상세 내용을 표시합니다.
import 'package:flutter/material.dart';
import 'package:ourora/features/common/presentation/widgets/nav_bar.dart';
import 'package:ourora/features/common/presentation/widgets/screen_content_sliver.dart';
import 'package:ourora/features/common/presentation/widgets/site_footer.dart';
import 'package:ourora/features/works/presentation/widgets/work_post/work_post_content_section.dart';

class WorkPostScreen extends StatelessWidget {
  // '/post/:id' 패턴으로 go_router가 :id를 동적 파라미터로 처리합니다.
  static const String routePattern = '/post/:id';

  // 특정 작품 ID의 URL 경로를 생성합니다. 예: routeFor('abc123') → '/post/abc123'
  static String routeFor(String id) => '/post/$id';

  final String workId; // URL에서 추출된 작품 ID

  const WorkPostScreen({super.key, required this.workId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(delegate: NavBarDelegate(), pinned: true),
          // workId를 WorkPostContentSection에 전달하여 해당 작품 데이터를 로드합니다.
          ScreenContentSliver(
            child: WorkPostContentSection(workId: workId),
          ),
          const SliverToBoxAdapter(child: SiteFooter()),
        ],
      ),
    );
  }
}
