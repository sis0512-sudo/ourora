import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';

class TitleDivider extends StatelessWidget {
  final bool? isSubTitle;

  const TitleDivider({super.key, this.isSubTitle});

  @override
  Widget build(BuildContext context) {
    bool isSubTitle = this.isSubTitle ?? false;

    return Container(
      width: 36,
      height: isSubTitle ? 3 : 6,
      color: AppTheme.lineGray,
      margin: EdgeInsets.only(top: isSubTitle ? 4 : 6),
    );
  }
}
