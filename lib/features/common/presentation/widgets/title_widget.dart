import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/responsive.dart';

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
    final isMobile = Responsive.isMobileDevice;

    return Column(
      crossAxisAlignment: widget.alignment ?? CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: widget.isSubTitle ? TextStyle(fontFamily: 'BMHanna', fontSize: isMobile ? 28 : 24, color: AppTheme.black) : AppTheme.pageTitle(isMobile),
        ),
        if (!widget.hideDivider)
          Container(
            width: isMobile ? 48 : 36,
            height: widget.isSubTitle ? 3 : 6,
            color: AppTheme.lineGray,
            margin: EdgeInsets.only(top: widget.isSubTitle ? 4 : 6),
          ),
      ],
    );
  }
}
