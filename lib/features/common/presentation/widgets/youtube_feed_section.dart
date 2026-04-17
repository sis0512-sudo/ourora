import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/domain/youtube_video.dart';
import 'package:ourora/features/common/presentation/providers/youtube_provider.dart';
import 'package:ourora/features/common/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

const double _cardWidth = 320;
const double _cardGap = 0;
const double _thumbnailHeight = 180;
const double _arrowWidth = 55;

class YoutubeFeedSection extends ConsumerStatefulWidget {
  const YoutubeFeedSection({super.key});

  @override
  ConsumerState<YoutubeFeedSection> createState() => _YoutubeFeedSectionState();
}

class _YoutubeFeedSectionState extends ConsumerState<YoutubeFeedSection> {
  final _scrollController = ScrollController();
  bool _atStart = true;
  bool _atEnd = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateArrows);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateArrows);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateArrows() {
    final pos = _scrollController.position;
    setState(() {
      _atStart = pos.pixels <= 0;
      _atEnd = pos.pixels >= pos.maxScrollExtent;
    });
  }

  void _scrollBy(double delta) {
    _scrollController.animateTo(
      (_scrollController.offset + delta).clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final videosAsync = ref.watch(youtubeVideosProvider);

    return Container(
      color: AppTheme.white,
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _arrowWidth + 32),
            child: Text('⠿  Youtube Feed', style: AppTheme.sectionTitle()),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: _thumbnailHeight + 140,
            child: videosAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const Center(child: Text('영상을 불러올 수 없습니다.')),
              data: (videos) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 32),
                  _ArrowButton(direction: _ArrowDirection.prev, disabled: _atStart, onTap: () => _scrollBy(-_cardWidth)),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: videos.length,
                      itemBuilder: (context, index) => _YoutubeCard(video: videos[index]),
                    ),
                  ),
                  _ArrowButton(direction: _ArrowDirection.next, disabled: _atEnd, onTap: () => _scrollBy(_cardWidth)),
                  const SizedBox(width: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _ArrowDirection { prev, next }

class _ArrowButton extends StatelessWidget {
  final _ArrowDirection direction;
  final bool disabled;
  final VoidCallback onTap;

  const _ArrowButton({required this.direction, required this.disabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isPrev = direction == _ArrowDirection.prev;
    return SizedBox(
      width: _arrowWidth,
      height: _thumbnailHeight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: disabled ? null : onTap,
          child: Center(child: Icon(isPrev ? Icons.chevron_left : Icons.chevron_right, size: 30, color: disabled ? Colors.black26 : AppTheme.black)),
        ),
      ),
    );
  }
}

class _YoutubeCard extends StatefulWidget {
  final YoutubeVideo video;

  const _YoutubeCard({required this.video});

  @override
  State<_YoutubeCard> createState() => _YoutubeCardState();
}

class _YoutubeCardState extends State<_YoutubeCard> {
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
          width: _cardWidth,
          margin: const EdgeInsets.only(right: _cardGap),
          color: AppTheme.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 썸네일
              Stack(
                children: [
                  CachedNetworkImage(imageUrl: widget.video.thumbnailUrl, width: _cardWidth, height: _thumbnailHeight, fit: BoxFit.cover),
                  // 어두운 오버레이 (hover 시 진해짐)
                  Positioned.fill(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      color: _hovered ? Colors.black.withValues(alpha: 0.5) : Colors.black.withValues(alpha: 0.25),
                    ),
                  ),
                  // 재생 버튼
                  Positioned.fill(
                    child: Center(
                      child: AnimatedScale(scale: _hovered ? 1.1 : 1.0, duration: const Duration(milliseconds: 200), child: _PlayIcon()),
                    ),
                  ),
                  // 영상 길이 (하단 우측)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      color: Colors.black.withValues(alpha: 0.75),
                      child: Text(
                        widget.video.duration,
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              // 제목 + 설명
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Text(
                  widget.video.title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.black, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.video.description.isNotEmpty)
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
