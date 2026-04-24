// 콘텐츠 영역을 최대 너비(980px)로 제한하고 가운데 정렬하는 Sliver 래퍼 위젯.
// CustomScrollView 안에서 SliverToBoxAdapter 대신 이 위젯을 사용하면
// 자동으로 windowMaxWidth 제한이 적용됩니다.
import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/constants.dart';

class ScreenContentSliver extends StatelessWidget {
  const ScreenContentSliver({super.key, required this.child});

  final Widget child; // 실제로 표시할 콘텐츠 위젯

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: AppTheme.white,
        child: Center(
          child: ConstrainedBox(
            // 콘텐츠 최대 너비를 980px로 제한합니다.
            constraints: BoxConstraints(maxWidth: AppConstants.windowMaxWidth),
            child: child,
          ),
        ),
      ),
    );
  }
}
