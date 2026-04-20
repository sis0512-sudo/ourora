import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/title_divider.dart';

class TitleWidget extends StatefulWidget {
  final String title;
  final bool isSubTitle;

  const TitleWidget({super.key, required this.title, required this.isSubTitle});

  @override
  State<TitleWidget> createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: widget.isSubTitle ? AppTheme.pageSubTitle() : AppTheme.pageTitle()),
        TitleDivider(isSubTitle: widget.isSubTitle),
      ],
    );
  }
}
