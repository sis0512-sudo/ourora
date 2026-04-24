// 섹션 제목과 그 아래 구분선을 함께 표시하는 재사용 가능한 위젯.
// 메인 타이틀(큰 글씨)과 서브 타이틀(작은 글씨) 두 가지 스타일을 지원합니다.
import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/responsive.dart';

class TitleWidget extends StatefulWidget {
  final String title;                  // 표시할 제목 텍스트
  final bool isSubTitle;               // true이면 서브타이틀 스타일(BMHanna, 작은 크기) 사용
  final CrossAxisAlignment? alignment; // 텍스트 정렬 방향 (기본: 왼쪽 정렬)
  final bool hideDivider;              // true이면 제목 아래 구분선을 숨깁니다

  const TitleWidget({super.key, required this.title, required this.isSubTitle, this.alignment, this.hideDivider = false});

  @override
  State<TitleWidget> createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return Column(
      crossAxisAlignment: widget.alignment ?? CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          // isSubTitle: BMHanna 폰트의 서브타이틀 스타일
          // !isSubTitle: pageTitle 스타일(더 크고 굵은 메인 타이틀)
          style: widget.isSubTitle ? TextStyle(fontFamily: 'BMHanna', fontSize: isMobile ? 28 : 24, color: AppTheme.black) : AppTheme.pageTitle(isMobile),
        ),
        if (!widget.hideDivider)
          // 제목 아래 짧은 구분선(색상 바)
          Container(
            width: isMobile ? 48 : 36,
            height: widget.isSubTitle ? 3 : 6, // 서브타이틀은 얇은 선, 메인 타이틀은 두꺼운 선
            color: AppTheme.lineGray,
            margin: EdgeInsets.only(top: widget.isSubTitle ? 4 : 6),
          ),
      ],
    );
  }
}
