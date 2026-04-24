import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/infrastructure/entities/youtube_video.dart';
import 'package:ourora/features/common/presentation/widgets/youtube_arrow_button.dart';
import 'package:ourora/features/common/utils/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

const double kYoutubeCardWidth = 320;
const double kYoutubeCardGap = 0;

class YoutubeCard extends StatefulWidget {
  final YoutubeVideo video;

  const YoutubeCard({super.key, required this.video});

  @override
  State<YoutubeCard> createState() => _YoutubeCardState();
}

class _YoutubeCardState extends State<YoutubeCard> {
  bool _hovered = false;

  String videoUrl(String videoId) => 'https://www.youtube.com/watch?v=$videoId';

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(videoUrl(widget.video.videoId)), mode: LaunchMode.externalApplication),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: Container(
          width: isMobile ? double.maxFinite : kYoutubeCardWidth,
          margin: const EdgeInsets.only(right: kYoutubeCardGap),
          color: AppTheme.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    widget.video.thumbnailUrl,
                    width: isMobile ? double.maxFinite : kYoutubeCardWidth,
                    height: isMobile ? null : kYoutubeThumbnailHeight,
                    fit: BoxFit.fitWidth,
                    cacheWidth: kYoutubeCardWidth.toInt(),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: kYoutubeCardWidth,
                        height: kYoutubeThumbnailHeight,
                        color: AppTheme.lightGray,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.coral,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned.fill(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      color: _hovered ? AppTheme.black.withValues(alpha: 0.5) : AppTheme.black.withValues(alpha: 0.25),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: AnimatedScale(scale: _hovered ? 1.1 : 1.0, duration: const Duration(milliseconds: 200), child: const _PlayIcon()),
                    ),
                  ),
                  if (!isMobile)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        color: AppTheme.black.withValues(alpha: 0.75),
                        child: Text(
                          widget.video.duration,
                          style: const TextStyle(color: AppTheme.white, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Text(
                  widget.video.title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.black, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.video.description.isNotEmpty && !isMobile)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: Text(
                    widget.video.description.replaceAll('\n', ' '),
                    style: TextStyle(fontSize: 12, color: AppTheme.textGray.withValues(alpha: 0.8), height: 1.6),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayIcon extends StatelessWidget {
  const _PlayIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(40, 40), painter: _PlayIconPainter());
  }
}

class _PlayIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final circlePaint = Paint()
      ..color = AppTheme.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final trianglePaint = Paint()
      ..color = AppTheme.white
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawCircle(center, radius - 1, circlePaint);

    final path = Path();
    final cx = center.dx;
    final cy = center.dy;
    path.moveTo(cx - 6, cy - 9);
    path.lineTo(cx + 12, cy);
    path.lineTo(cx - 6, cy + 9);
    path.close();
    canvas.drawPath(path, trianglePaint);
  }

  @override
  bool shouldRepaint(_PlayIconPainter oldDelegate) => false;
}
