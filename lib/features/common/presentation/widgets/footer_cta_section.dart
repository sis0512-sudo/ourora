import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';

class FooterCtaSection extends StatelessWidget {
  const FooterCtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 510,
      color: AppTheme.darkBg,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('YOUR OWN LIGHT', style: AppTheme.footerCtaTitle()),
            const SizedBox(height: 16),
            Text(
              'MAKE YOU SHINE IN THE WORLD',
              style: AppTheme.footerCtaSubtitle(),
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              onPressed: () {},
              child: Text(
                'Read More >>',
                style: AppTheme.navItem().copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
