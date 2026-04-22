import 'package:flutter/material.dart';
import 'package:ourora/features/common/presentation/widgets/feature_cards_section.dart';
import 'package:ourora/features/common/presentation/widgets/fid_section.dart';
import 'package:ourora/features/common/presentation/widgets/footer_cta_section.dart';
import 'package:ourora/features/common/presentation/widgets/hero_slider.dart';
import 'package:ourora/features/common/presentation/widgets/instagram_grid_section.dart';
import 'package:ourora/features/common/presentation/widgets/nav_bar.dart';
import 'package:ourora/features/common/presentation/widgets/screen_content_sliver.dart';
import 'package:ourora/features/common/presentation/widgets/site_footer.dart';
import 'package:ourora/features/common/presentation/widgets/youtube_feed_section.dart';
import 'package:ourora/features/common/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  static const String route = '/';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _imagesPrecached = false;

  static const String _footerCtaUrl =
      'https://firebasestorage.googleapis.com/v0/b/ourora-78e54.firebasestorage.app/o/images%2Ffooter_cta_background.webp?alt=media&token=372ab332-88c0-4348-aa3f-679c2daa8c7b';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_imagesPrecached) return;
    _imagesPrecached = true;

    for (final slide in AppConstants.heroSlides) {
      precacheImage(NetworkImage(slide.imageUrl), context);
    }
    for (final url in [
      _footerCtaUrl,
      'https://firebasestorage.googleapis.com/v0/b/ourora-78e54.firebasestorage.app/o/images%2Ffidp_background.webp?alt=media&token=cbe81dfb-ddc0-437c-821b-73bbfd0518bf',
      'https://firebasestorage.googleapis.com/v0/b/ourora-78e54.firebasestorage.app/o/images%2Fmachine_list.webp?alt=media&token=b7a3113e-619b-4bf5-abd0-26365484f931',
      'https://firebasestorage.googleapis.com/v0/b/ourora-78e54.firebasestorage.app/o/images%2Fregular_course_timetable.webp?alt=media&token=2cdffe85-f2d4-450e-afac-f071e2427388',
    ]) {
      precacheImage(NetworkImage(url), context);
    }
  }

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
