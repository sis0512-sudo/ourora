import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/responsive.dart';

class MembershipCard extends StatelessWidget {
  const MembershipCard({
    super.key,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.description,
  });

  final Color bgColor;
  final String title;
  final String subtitle;
  final String description;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return Container(
      color: bgColor,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 32 : 60,
        vertical: 40,
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isMobile
            ? [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'BMHanna',
                    fontSize: 35,
                    color: AppTheme.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  subtitle,
                  style: GoogleFonts.notoSansKr(
                    fontSize: isMobile ? 20 : 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  description,
                  style: GoogleFonts.notoSansKr(
                    fontSize: 16,
                    color: AppTheme.white,
                  ),
                ),
              ]
            : [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'BMHanna',
                    fontSize: 35,
                    color: AppTheme.white,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        subtitle,
                        style: GoogleFonts.notoSansKr(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.white,
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 100,
                      color: AppTheme.white,
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                    ),
                    Expanded(
                      child: Text(
                        description,
                        style: GoogleFonts.notoSansKr(
                          fontSize: 16,
                          color: AppTheme.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
      ),
    );
  }
}
