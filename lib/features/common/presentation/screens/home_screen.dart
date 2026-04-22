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

class HomeScreen extends ConsumerStatefulWidget {
  static const String route = '/';

  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPersistentHeader(delegate: NavBarDelegate(), pinned: true),
          const SliverToBoxAdapter(child: HeroSlider()),
          const ScreenContentSliver(child: FeatureCardsSection()),
          const SliverToBoxAdapter(child: InstagramGridSection()),
          const ScreenContentSliver(child: FidSection()),
          const SliverToBoxAdapter(child: YoutubeFeedSection()),
          SliverToBoxAdapter(child: FooterCtaSection(scrollController: _scrollController)),
          const SliverToBoxAdapter(child: SiteFooter()),
        ],
      ),
    );
  }
}
