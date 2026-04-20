import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/title_widget.dart';

class BulletList extends StatelessWidget {
  final String title;
  final List<String> items;

  const BulletList({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(title: title, isSubTitle: true),
        const SizedBox(height: 20),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: AppTheme.bodyKorean().copyWith(fontWeight: FontWeight.bold)),
                Expanded(child: Text(item, style: AppTheme.bodyKorean())),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
