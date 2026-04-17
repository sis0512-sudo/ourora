import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/nav_bar.dart';
import 'package:ourora/features/common/presentation/widgets/site_footer.dart';
import 'package:ourora/features/contact/presentation/widgets/contact_info_panel.dart';
import 'package:ourora/features/contact/presentation/widgets/contact_map_view.dart';
import 'package:ourora/features/contact/presentation/widgets/contact_parking_panel.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key, this.titleStyle, this.bodyStyle});

  final TextStyle? titleStyle;
  final TextStyle? bodyStyle;

  @override
  Widget build(BuildContext context) {
    registerContactMapView();
    return Scaffold(
      backgroundColor: AppTheme.black,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(delegate: NavBarDelegate(), pinned: true),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 450, child: ContactMapView()),
                ContactInfoPanel(titleStyle: titleStyle, bodyStyle: bodyStyle),
                ContactParkingPanel(
                  titleStyle: titleStyle,
                  bodyStyle: bodyStyle,
                ),
                Container(height: 180, color: AppTheme.white),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SiteFooter()),
        ],
      ),
    );
  }
}
