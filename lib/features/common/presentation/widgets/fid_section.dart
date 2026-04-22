import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/about/presentation/screens/fidp_screen.dart';
import 'package:ourora/features/common/utils/constants.dart';
import 'package:ourora/features/common/utils/responsive.dart';

class FidSection extends StatelessWidget {
  const FidSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return Container(
      color: AppTheme.white,
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: AppConstants.windowMaxWidth),
          child: Column(
            children: [
              Text(
                '오로라 공방은?',
                style: TextStyle(
                  fontFamily: 'BMHanna',
                  fontSize: isMobile ? 28 : 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 4,
                  color: AppTheme.darkBg,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: isMobile ? 60 : 40,
                height: 3,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppTheme.darkBg, width: 3),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              isMobile
                  ? Column(
                      children: AppConstants.fidItems.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: _FidItem(
                            letter: item['letter']!,
                            title: item['title']!,
                            desc: item['desc']!,
                          ),
                        );
                      }).toList(),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: AppConstants.fidItems.map((item) {
                        return SizedBox(
                          width: 245,
                          child: _FidItem(
                            letter: item['letter']!,
                            title: item['title']!,
                            desc: item['desc']!,
                          ),
                        );
                      }).toList(),
                    ),
              const SizedBox(height: 48),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.black),
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 50 : 40,
                    vertical: isMobile ? 20 : 16,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  overlayColor: AppTheme.transparent,
                  surfaceTintColor: AppTheme.transparent,
                ),
                onPressed: () => context.go(FIDPScreen.route),
                child: Text('Read More >>', style: AppTheme.navItem(isMobile)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FidItem extends StatelessWidget {
  final String letter;
  final String title;
  final String desc;

  const _FidItem({
    required this.letter,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return Padding(
      padding: isMobile
          ? EdgeInsets.symmetric(horizontal: 40)
          : EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            letter,
            style: TextStyle(
              fontFamily: 'ArialBlack',
              fontSize: isMobile ? 80 : 70,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.notoSansKr(
              fontSize: isMobile ? 24 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            desc,
            style: GoogleFonts.notoSansKr(fontSize: isMobile ? 20 : 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
