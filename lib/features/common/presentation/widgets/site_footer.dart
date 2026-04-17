import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/constants.dart';
import 'package:ourora/features/common/utils/responsive.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      color: AppTheme.darkBg,
      constraints: const BoxConstraints(minHeight: 231),
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ..._footerTextItems(),
                      const SizedBox(height: 24),
                      _logoWidget(),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _footerTextItems(),
                      ),
                      _logoWidget(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  List<Widget> _footerTextItems() {
    return [
      Text('© 2021 OURORA STUDIO.', style: _footerText()),
      Text('All rights reserved.', style: _footerText()),
      Text(AppConstants.address, style: _footerText()),
      Text(AppConstants.email, style: _footerText()),
      Text('T. ${AppConstants.phone}', style: _footerText()),
    ];
  }

  Widget _logoWidget() {
    return Image.asset(
      'assets/images/logo.png',
      width: 221,
      height: 60,
      fit: BoxFit.contain,
    );
  }

  TextStyle _footerText() => GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w100,
        color: AppTheme.white,
        height: 1.8,
      );
}
