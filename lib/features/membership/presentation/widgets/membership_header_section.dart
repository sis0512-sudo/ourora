import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/title_widget.dart';

class MembershipHeaderSection extends StatelessWidget {
  const MembershipHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const TitleWidget(title: '오로라 멤버십', isSubTitle: false),
          const SizedBox(height: 20),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset('assets/svgs/ourora_membership_logo.svg', height: 200),
                Text(
                  'OURORA MEMBERSHIP',
                  style: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.bold, color: AppTheme.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
