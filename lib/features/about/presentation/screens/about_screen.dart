import 'package:flutter/material.dart';
import 'package:ourora/features/about/presentation/widgets/about_brand_section.dart';
import 'package:ourora/features/about/presentation/widgets/about_fidp_section.dart';
import 'package:ourora/features/about/presentation/widgets/about_profile_section.dart';
import 'package:ourora/features/common/presentation/widgets/nav_bar.dart';
import 'package:ourora/features/common/presentation/widgets/site_footer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: NavBarDelegate(),
            pinned: true,
          ),
          const SliverToBoxAdapter(child: AboutBrandSection()),
          const SliverToBoxAdapter(child: AboutFidpSection()),
          const SliverToBoxAdapter(child: AboutProfileSection()),
          const SliverToBoxAdapter(child: SiteFooter()),
        ],
      ),
    );
  }
}
