import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/infrastructure/entities/youtube_video.dart';
import 'package:ourora/features/common/presentation/widgets/youtube_arrow_button.dart';
import 'package:ourora/features/common/utils/constants.dart';
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(AppConstants.videoUrl(widget.video.videoId)), mode: LaunchMode.externalApplication),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: Container(
          width: kYoutubeCardWidth,
          margin: const EdgeInsets.only(right: kYoutubeCardGap),
          color: AppTheme.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CachedNetworkImage(imageUrl: widget.video.thumbnailUrl, width: kYoutubeCardWidth, height: kYoutubeThumbnailHeight, fit: BoxFit.cover),
                  Positioned.fill(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      color: _hovered ? Colors.black.withValues(alpha: 0.5) : Colors.black.withValues(alpha: 0.25),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: AnimatedScale(scale: _hovered ? 1.1 : 1.0, duration: const Duration(milliseconds: 200), child: const _PlayIcon()),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      color: Colors.black.withValues(alpha: 0.75),
                      child: Text(widget.video.duration, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Text(widget.video.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.black, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
              if (widget.video.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: Text(widget.video.description.replaceAll('\n', ' '), style: TextStyle(fontSize: 12, color: AppTheme.textGray.withValues(alpha: 0.8), height: 1.6), maxLines: 2, overflow: TextOverflow.ellipsis),
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
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final trianglePaint = Paint()
      ..color = Colors.white
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
