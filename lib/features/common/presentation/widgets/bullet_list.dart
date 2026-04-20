import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/title_widget.dart';

class BulletList extends StatelessWidget {
  final String? title;
  final List<TextSpan> items;
  final bool hideDivider;

  const BulletList({super.key, this.title, required this.items, this.hideDivider = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) TitleWidget(title: title!, isSubTitle: true, hideDivider: hideDivider),
        const SizedBox(height: 20),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: AppTheme.bodyKorean().copyWith(fontWeight: FontWeight.bold, height: 1.5)),
                Expanded(
                  child: RichText(
                    text: TextSpan(style: AppTheme.bodyKorean().copyWith(height: 1.5), children: [item]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
