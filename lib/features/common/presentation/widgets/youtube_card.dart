// YouTube 영상 하나를 카드 형태로 표시하는 위젯.
// 썸네일·재생 아이콘·제목·설명·재생 시간을 포함하며,
// 클릭 시 YouTube 앱/브라우저에서 해당 영상을 엽니다.
import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/infrastructure/entities/youtube_video.dart';
import 'package:ourora/features/common/presentation/widgets/youtube_arrow_button.dart';
import 'package:ourora/features/common/utils/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

const double kYoutubeCardWidth = 320; // 데스크톱 카드 너비 (px)
const double kYoutubeCardGap = 0;     // 카드 사이 간격

class YoutubeCard extends StatefulWidget {
  final YoutubeVideo video;

  const YoutubeCard({super.key, required this.video});

  @override
  State<YoutubeCard> createState() => _YoutubeCardState();
}

class _YoutubeCardState extends State<YoutubeCard> {
  bool _hovered = false; // 마우스 호버 상태

  // videoId로 YouTube 영상 URL을 생성합니다.
  String videoUrl(String videoId) => 'https://www.youtube.com/watch?v=$videoId';

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return GestureDetector(
      // 클릭 시 YouTube를 새 탭/앱에서 엽니다.
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
                  // 썸네일 이미지
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
                  // 호버 시 어두워지는 오버레이
                  Positioned.fill(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      color: _hovered ? AppTheme.black.withValues(alpha: 0.5) : AppTheme.black.withValues(alpha: 0.25),
                    ),
                  ),
                  // 중앙 재생 버튼 (호버 시 살짝 확대)
                  Positioned.fill(
                    child: Center(
                      child: AnimatedScale(scale: _hovered ? 1.1 : 1.0, duration: const Duration(milliseconds: 200), child: const _PlayIcon()),
                    ),
                  ),
                  // 우하단 재생 시간 표시 (데스크톱만)
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
              // 영상 제목 (최대 2줄)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Text(
                  widget.video.title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.black, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // 영상 설명 (데스크톱, 최대 2줄)
              if (widget.video.description.isNotEmpty && !isMobile)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: Text(
                    widget.video.description.replaceAll('\n', ' '), // 줄바꿈을 공백으로 치환
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

// 재생 버튼 아이콘 (원 + 삼각형을 CustomPainter로 직접 그립니다)
class _PlayIcon extends StatelessWidget {
  const _PlayIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(40, 40), painter: _PlayIconPainter());
  }
}

// Canvas API로 원과 삼각형을 그리는 CustomPainter
class _PlayIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 원 테두리 스타일
    final circlePaint = Paint()
      ..color = AppTheme.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // 삼각형(재생 아이콘) 채우기 스타일
    final trianglePaint = Paint()
      ..color = AppTheme.white
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 원 그리기
    canvas.drawCircle(center, radius - 1, circlePaint);

    // 삼각형 그리기 (Path로 세 꼭짓점 연결)
    final path = Path();
    final cx = center.dx;
    final cy = center.dy;
    path.moveTo(cx - 6, cy - 9);  // 왼쪽 상단
    path.lineTo(cx + 12, cy);     // 오른쪽 중앙
    path.lineTo(cx - 6, cy + 9);  // 왼쪽 하단
    path.close();
    canvas.drawPath(path, trianglePaint);
  }

  @override
  bool shouldRepaint(_PlayIconPainter oldDelegate) => false; // 상태 변화 없으므로 재그리기 불필요
}
