import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/responsive.dart';

class ClassEnvironmentSection extends StatelessWidget {
  const ClassEnvironmentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Container(
      color: AppTheme.lightGray,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80, vertical: 80),
      child: Column(
        children: [
          Text(
            'CLASS ENVIRONMENT',
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 4,
              color: AppTheme.textGray,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '수업 환경',
            style: GoogleFonts.notoSansKr(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.black,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Container(width: 40, height: 1, color: AppTheme.black),
          const SizedBox(height: 48),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              children: [
                _EnvironmentRow(label: '메인 작업실', value: '2인용 테이블 3개'),
                _EnvironmentRow(label: '기계실', value: '2인용 테이블 1개'),
                _EnvironmentRow(label: '개인 작업 테이블', value: '1인용 테이블 2개 · 확장형 테이블 1개'),
                const SizedBox(height: 40),
                ClipRRect(
                  child: Image.asset(
                    'assets/images/machine_list.webp',
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Container(
                      height: 200,
                      color: AppTheme.borderGray,
                      child: const Center(
                        child: Icon(Icons.image_outlined, size: 48, color: AppTheme.textGray),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          Text(
            '문의 및 수강 신청',
            style: GoogleFonts.notoSansKr(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'contact@ourora.com  ·  010-7586-8765',
            style: GoogleFonts.notoSansKr(fontSize: 14, color: AppTheme.textGray, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}

class _EnvironmentRow extends StatelessWidget {
  final String label;
  final String value;

  const _EnvironmentRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.borderGray)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.notoSansKr(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.black,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.notoSansKr(fontSize: 13, color: AppTheme.textGray),
          ),
        ],
      ),
    );
  }
}
