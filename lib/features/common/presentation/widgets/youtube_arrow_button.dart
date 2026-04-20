import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';

const double kYoutubeArrowWidth = 55;
const double kYoutubeThumbnailHeight = 180;

enum YoutubeArrowDirection { prev, next }

class YoutubeArrowButton extends StatelessWidget {
  final YoutubeArrowDirection direction;
  final bool disabled;
  final VoidCallback onTap;

  const YoutubeArrowButton({super.key, required this.direction, required this.disabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isPrev = direction == YoutubeArrowDirection.prev;
    return SizedBox(
      width: kYoutubeArrowWidth,
      height: kYoutubeThumbnailHeight,
      child: Material(
        color: AppTheme.transparent,
        child: InkWell(
          onTap: disabled ? null : onTap,
          child: Center(child: Icon(isPrev ? Icons.chevron_left : Icons.chevron_right, size: 30, color: disabled ? AppTheme.black.withValues(alpha: 0.26) : AppTheme.black)),
        ),
      ),
    );
  }
}
