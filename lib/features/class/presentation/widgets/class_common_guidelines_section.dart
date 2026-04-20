import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/responsive.dart';

class ClassCommonGuidelinesSection extends StatelessWidget {
  const ClassCommonGuidelinesSection({super.key});

  static const List<Map<String, String>> _guidelines = [
    {
      'title': '개인별 진도',
      'body': '모든 과정의 기간은 개인별 진도에 따라 달라질 수 있습니다.',
    },
    {
      'title': '보충 수업',
      'body': '필요시 보충 수업이 있을 수 있습니다.',
    },
    {
      'title': '중복 수강 할인',
      'body': '수료 후 일부 중복되는 커리큘럼으로 등록시(예: 정규과정 중급반 이수 후 전문가반 등록시), 일정 할인을 제공합니다.',
    },
    {
      'title': '환불 정책',
      'body': '수업료 환불은 최초 1회 수업 전까지 100% 환불되며, 그 이후부터는 환불되지 않습니다.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80, vertical: 80),
      color: AppTheme.white,
      child: Column(
        children: [
          Text(
            '공통 안내',
            style: GoogleFonts.notoSansKr(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.black,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 16),
          Container(width: 40, height: 1, color: AppTheme.black),
          const SizedBox(height: 48),
          isMobile
              ? Column(
                  children: _guidelines
                      .map(
                        (g) => Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: _GuidelineItem(title: g['title']!, body: g['body']!),
                        ),
                      )
                      .toList(),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _guidelines
                      .map(
                        (g) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _GuidelineItem(title: g['title']!, body: g['body']!),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ],
      ),
    );
  }
}

class _GuidelineItem extends StatelessWidget {
  final String title;
  final String body;

  const _GuidelineItem({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.borderGray),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 20, color: AppTheme.black),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: GoogleFonts.notoSansKr(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          body,
          style: GoogleFonts.notoSansKr(fontSize: 13, height: 1.8, color: AppTheme.textGray),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
