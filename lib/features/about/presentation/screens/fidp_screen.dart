import 'package:flutter/material.dart';
import 'package:ourora/features/common/presentation/widgets/nav_bar.dart';
import 'package:ourora/features/common/presentation/widgets/site_footer.dart';

class FIDPScreen extends StatefulWidget {
  static const String route = '/fidp';

  const FIDPScreen({super.key});

  @override
  State<FIDPScreen> createState() => _FIDPScreenState();
}

class _FIDPScreenState extends State<FIDPScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(delegate: NavBarDelegate(), pinned: true),
          const SliverToBoxAdapter(child: SiteFooter()),
        ],
      ),
    );
  }
}
