import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/nav_bar.dart';
import 'package:ourora/features/common/presentation/widgets/screen_content_sliver.dart';
import 'package:ourora/features/common/presentation/widgets/site_footer.dart';
import 'package:ourora/features/membership/presentation/widgets/membership_common_terms_section.dart';
import 'package:ourora/features/membership/presentation/widgets/membership_header_section.dart';
import 'package:ourora/features/membership/presentation/widgets/membership_partnership_section.dart';
import 'package:ourora/features/membership/presentation/widgets/membership_share_section.dart';

class MembershipScreen extends StatelessWidget {
  static const String route = '/membership';

  const MembershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(delegate: NavBarDelegate(), pinned: true),
          ScreenContentSliver(
            child: const Column(
              children: [
                MembershipHeaderSection(),
                MembershipShareSection(),
                MembershipPartnershipSection(),
                MembershipCommonTermsSection(),
                SizedBox(height: 200),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SiteFooter()),
        ],
      ),
    );
  }
}
