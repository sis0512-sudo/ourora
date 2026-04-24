// 모든 페이지 최하단에 공통으로 표시되는 사이트 푸터(바닥글).
// 저작권·주소·이메일·전화번호와 로고를 표시합니다.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/constants.dart';
import 'package:ourora/features/common/utils/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

// 푸터 텍스트 스타일 (얇은 회색 Noto Sans KR)
TextStyle _footerText() => GoogleFonts.notoSansKr(
  fontSize: 14,
  height: 1.5,
  fontWeight: FontWeight.w100,
  color: AppTheme.textGray,
);

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return Container(
      width: double.infinity,
      color: AppTheme.black,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: AppConstants.windowMaxWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              // 모바일: 가운데 정렬, 데스크톱: 왼쪽 정렬
              crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              children: isMobile
                  ? [
                      // 모바일 레이아웃: 로고 → 주소 → 연락처 → 저작권 세로 배치
                      // ColorFiltered: 이미지 색상을 반전시켜 흰색 로고로 표시
                      ColorFiltered(
                        colorFilter: const ColorFilter.matrix([-1, 0, 0, 0, 255, 0, -1, 0, 0, 255, 0, 0, -1, 0, 255, 0, 0, 0, 1, 0]),
                        child: Image.asset('assets/images/logo.png', width: 221, height: 60, fit: BoxFit.contain),
                      ),
                      const SizedBox(height: 60),
                      _FooterTextBlock(lines: const ['B1 6 Mokdong-ro21Gil, Yangcheon-gu,', 'Seoul, Korea.']),
                      const SizedBox(height: 20),
                      // 이메일 클릭 시 메일 앱 실행
                      GestureDetector(
                        onTap: () => launchUrl(Uri.parse('mailto:contact@ourora.com')),
                        child: Text('E. contact@ourora.com', style: _footerText()),
                      ),
                      Text('T. 010-7586-8765', style: _footerText()),
                      const SizedBox(height: 20),
                      _FooterTextBlock(lines: const ['© 2021 OURORA STUDIO.', 'All rights reserved.']),
                      const SizedBox(height: 60),
                    ]
                  : [
                      // 데스크톱 레이아웃: 저작권·주소·연락처 가로 배치 → 로고
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
                                  child: Text('E. contact@ourora.com', style: _footerText()),
                                ),
                                Text('T. 010-7586-8765', style: _footerText()),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                      // 흰색 로고 (색상 반전 필터 적용)
                      ColorFiltered(
                        colorFilter: const ColorFilter.matrix([-1, 0, 0, 0, 255, 0, -1, 0, 0, 255, 0, 0, -1, 0, 255, 0, 0, 0, 1, 0]),
                        child: Image.asset('assets/images/logo.png', width: 221, height: 60, fit: BoxFit.contain),
                      ),
                    ],
            ),
          ),
        ),
      ),
    );
  }
}

// 여러 줄의 텍스트를 Column으로 묶어서 표시하는 내부 위젯
class _FooterTextBlock extends StatelessWidget {
  final List<String> lines;
  const _FooterTextBlock({required this.lines});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: lines.map((line) => Text(line, style: _footerText(), textAlign: isMobile ? TextAlign.center : TextAlign.left)).toList(),
    );
  }
}
