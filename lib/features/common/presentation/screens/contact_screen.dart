import 'package:flutter/material.dart';
import 'package:ourora/features/common/presentation/widgets/nav_bar.dart';
import 'package:ourora/features/common/presentation/widgets/site_footer.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: NavBarDelegate(),
            pinned: true,
          ),
          const SliverFillRemaining(
            child: Center(
              child: Text('CONTACT'),
            ),
          ),
          const SliverToBoxAdapter(child: SiteFooter()),
        ],
      ),
    );
  }
}
