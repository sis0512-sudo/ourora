// 홈페이지 화면(/)을 구성하는 최상위 스크린 위젯.
// CustomScrollView + Sliver 조합으로 스크롤 가능한 섹션들을 순서대로 배치합니다.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourora/features/common/presentation/widgets/feature_cards_section.dart';
import 'package:ourora/features/common/presentation/widgets/fid_section.dart';
import 'package:ourora/features/common/presentation/widgets/footer_cta_section.dart';
import 'package:ourora/features/common/presentation/widgets/hero_slider.dart';
import 'package:ourora/features/common/presentation/widgets/instagram_grid_section.dart';
import 'package:ourora/features/common/presentation/widgets/nav_bar.dart';
import 'package:ourora/features/common/presentation/widgets/screen_content_sliver.dart';
import 'package:ourora/features/common/presentation/widgets/site_footer.dart';
import 'package:ourora/features/common/presentation/widgets/youtube_feed_section.dart';
import 'package:ourora/features/works/application/works_controller.dart';

// ConsumerStatefulWidget: Riverpod의 ref를 사용할 수 있는 StatefulWidget
class HomeScreen extends ConsumerStatefulWidget {
  static const String route = '/'; // go_router에서 이 화면의 URL 경로

  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // FooterCtaSection의 패럴랙스 효과를 위해 스크롤 컨트롤러를 전달합니다.
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose(); // 위젯 소멸 시 컨트롤러 메모리 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // worksControllerProvider를 watch하여 홈 화면 진입 시 작품 데이터를 미리 로드합니다.
    // ignore: unused_local_variable
    final state = ref.watch(worksControllerProvider);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        // Sliver: CustomScrollView 내에서 사용하는 스크롤 가능한 요소들
        slivers: [
          // 상단 고정(pinned) 네비게이션 바
          SliverPersistentHeader(delegate: NavBarDelegate(), pinned: true),
          // 전체 화면 히어로 이미지 슬라이더
          const SliverToBoxAdapter(child: HeroSlider()),
          // WORKSHOP / WORKS / CLASS / MEMBERSHIP 카드 4개
          const ScreenContentSliver(child: FeatureCardsSection()),
          // 인스타그램 사진 그리드 (Load More 지원)
          const SliverToBoxAdapter(child: InstagramGridSection()),
          // F·I·D·P 4열 섹션
          const ScreenContentSliver(child: FidSection()),
          // YouTube 영상 가로 스크롤 피드
          const SliverToBoxAdapter(child: YoutubeFeedSection()),
          // 패럴랙스 배경의 CTA(Call-To-Action) 섹션
          SliverToBoxAdapter(child: FooterCtaSection(scrollController: _scrollController)),
          // 주소·연락처 하단 푸터
          const SliverToBoxAdapter(child: SiteFooter()),
        ],
      ),
    );
  }
}
