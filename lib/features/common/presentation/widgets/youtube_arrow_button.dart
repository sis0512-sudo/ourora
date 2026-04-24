// YouTube 피드 섹션에서 가로 스크롤을 위한 좌/우 화살표 버튼 위젯.
// disabled 상태에서는 클릭이 불가능하며 아이콘이 흐리게 표시됩니다.
import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';

// YouTube 섹션 레이아웃 상수 (youtube_card.dart에서도 참조)
const double kYoutubeArrowWidth = 55;       // 화살표 버튼 너비
const double kYoutubeThumbnailHeight = 180; // 썸네일 높이 (화살표 버튼 높이와 맞춤)

// 화살표 방향 열거형
enum YoutubeArrowDirection { prev, next }

class YoutubeArrowButton extends StatelessWidget {
  final YoutubeArrowDirection direction; // 좌(prev) 또는 우(next) 방향
  final bool disabled;                   // true이면 버튼 비활성화 (스크롤 끝에 도달)
  final VoidCallback onTap;             // 버튼 클릭 시 실행할 콜백

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
          onTap: disabled ? null : onTap, // disabled이면 null → 탭 이벤트 무시
          child: Center(child: Icon(
            isPrev ? Icons.chevron_left : Icons.chevron_right,
            size: 30,
            // disabled이면 흐린 색상, 활성 상태이면 선명한 검정색
            color: disabled ? AppTheme.black.withValues(alpha: 0.26) : AppTheme.black,
          )),
        ),
      ),
    );
  }
}
