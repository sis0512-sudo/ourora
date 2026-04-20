import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/title_widget.dart';

class ClassHeaderSection extends StatelessWidget {
  const ClassHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const TitleWidget(title: 'CLASS', isSubTitle: false),
          const SizedBox(height: 40),
          Text(
            '처음 목공을 배우러 여기저기 이곳 저곳을 힘들게 알아보았던 때를 기억합니다.\n그 어려움을 알기에, 오로라공방은 정말 필요로 하는 프로그램을 만들기로 했습니다.',
            style: GoogleFonts.nanumMyeongjo(fontSize: 22, color: AppTheme.black),
          ),
        ],
      ),
    );
  }
}
