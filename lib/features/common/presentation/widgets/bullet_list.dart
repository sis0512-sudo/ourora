// 글머리 기호(•)가 붙은 목록을 표시하는 재사용 가능한 위젯.
// 선택적 제목과 함께 사용할 수 있으며, 마지막 항목을 굵게 강조하는 옵션이 있습니다.
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/title_widget.dart';
import 'package:ourora/features/common/utils/responsive.dart';

class BulletList extends StatelessWidget {
  final String? title;          // 목록 위에 표시할 제목 (없으면 생략)
  final List<TextSpan> items;   // 글머리 기호가 붙을 항목들 (TextSpan으로 서식 지정 가능)
  final TextStyle? itemStyle;   // 항목 텍스트 스타일 (없으면 기본 bodyKorean 사용)
  final bool hideDivider;       // true이면 제목 아래 구분선 숨기기
  final bool boldLast;          // true이면 마지막 항목을 굵게 표시

  const BulletList({super.key, this.title, required this.items, this.itemStyle, this.hideDivider = false, this.boldLast = false});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    TextStyle itemBaseStyle = itemStyle ?? AppTheme.bodyKorean(isMobile);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목이 있을 때만 TitleWidget을 표시합니다.
        if (title != null) TitleWidget(title: title!, isSubTitle: true, hideDivider: hideDivider),
        const SizedBox(height: 20),
        // mapIndexed: 인덱스와 값을 함께 순회하는 컬렉션 패키지의 확장 메서드
        ...items.mapIndexed((index, item) {
          bool isLast = index == items.length - 1;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 글머리 기호 '•'
                Text('• ', style: itemBaseStyle.copyWith(fontWeight: FontWeight.bold, height: 1.5)),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      // boldLast가 true이고 마지막 항목이면 굵게 표시
                      style: itemBaseStyle.copyWith(height: 1.5, fontWeight: isLast && boldLast ? FontWeight.bold : FontWeight.normal),
                      children: [item],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
