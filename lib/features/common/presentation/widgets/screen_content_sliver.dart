import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/constants.dart';

class ScreenContentSliver extends StatelessWidget {
  const ScreenContentSliver({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: AppTheme.white,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: AppConstants.windowMaxWidth),
            child: child,
          ),
        ),
      ),
    );
  }
}
