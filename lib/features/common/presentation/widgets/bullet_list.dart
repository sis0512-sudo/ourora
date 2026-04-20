import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/title_widget.dart';

class BulletList extends StatelessWidget {
  final String? title;
  final List<TextSpan> items;
  final TextStyle? itemStyle;
  final bool hideDivider;
  final bool boldLast;

  const BulletList({super.key, this.title, required this.items, this.itemStyle, this.hideDivider = false, this.boldLast = false});

  @override
  Widget build(BuildContext context) {
    TextStyle itemBaseStyle = itemStyle ?? AppTheme.bodyKorean();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) TitleWidget(title: title!, isSubTitle: true, hideDivider: hideDivider),
        const SizedBox(height: 20),
        ...items.mapIndexed((index, item) {
          bool isLast = index == items.length - 1;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: itemBaseStyle.copyWith(fontWeight: FontWeight.bold, height: 1.5)),
                Expanded(
                  child: RichText(
                    text: TextSpan(
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
