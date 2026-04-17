import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.black,
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Wrap(
              spacing: 40,
              runSpacing: 24,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // 저작권
                _FooterTextBlock(lines: const ['© 2021 OURORA STUDIO.', 'All rights reserved.']),

                // 주소
                _FooterTextBlock(lines: const ['B1 6 Mokdong-ro21Gil, Yangcheon-gu,', 'Seoul, Korea.']),

                // 이메일 + 전화
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => launchUrl(Uri.parse('mailto:contact@ourora.com')),
                      child: const Text(
                        'E. contact@ourora.com',
                        style: TextStyle(color: AppTheme.textGray, fontSize: 14, height: 1.5, fontFamily: 'Roboto', fontWeight: FontWeight.w100),
                      ),
                    ),
                    const Text(
                      'T. 010-7586-8765',
                      style: TextStyle(color: AppTheme.textGray, fontSize: 14, height: 1.5, fontFamily: 'Roboto', fontWeight: FontWeight.w100),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          // 로고
          ColorFiltered(
            colorFilter: const ColorFilter.matrix([-1, 0, 0, 0, 255, 0, -1, 0, 0, 255, 0, 0, -1, 0, 255, 0, 0, 0, 1, 0]),
            child: Image.asset('assets/images/logo.png', width: 221, height: 60, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}

class _FooterTextBlock extends StatelessWidget {
  final List<String> lines;
  const _FooterTextBlock({required this.lines});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines
          .map(
            (line) => Text(
              line,
              style: const TextStyle(color: AppTheme.textGray, fontSize: 14, height: 1.5, fontFamily: 'Roboto', fontWeight: FontWeight.w100),
            ),
          )
          .toList(),
    );
  }
}
