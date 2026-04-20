import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/title_divider.dart';

class TitleWidget extends StatefulWidget {
  final String title;
  final bool isSubTitle;
  final CrossAxisAlignment? alignment;
  final bool hideDivider;

  const TitleWidget({super.key, required this.title, required this.isSubTitle, this.alignment, this.hideDivider = false});

  @override
  State<TitleWidget> createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.alignment ?? CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: widget.isSubTitle ? const TextStyle(fontFamily: 'BMHanna', fontSize: 24, color: AppTheme.black) : AppTheme.pageTitle()),
        if (!widget.hideDivider) TitleDivider(isSubTitle: widget.isSubTitle),
      ],
    );
  }
}
