// 이미지를 전체 화면 팝업으로 확대 표시하는 위젯.
// 여러 장의 이미지를 좌우 버튼 또는 키보드(←→) 방향키로 넘길 수 있습니다.
// ImageViewerPopup.show()로 다이얼로그 형태로 띄웁니다.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ourora/config/theme.dart';

class ImageViewerPopup extends StatefulWidget {
  final List<String> imageUrls; // 표시할 이미지 URL 목록
  final int initialIndex;       // 처음 표시할 이미지의 인덱스 (기본값: 0)

  const ImageViewerPopup({super.key, required this.imageUrls, this.initialIndex = 0});

  // 정적 메서드로 팝업을 쉽게 띄울 수 있습니다.
  // 사용법: ImageViewerPopup.show(context, imageUrls: [...], initialIndex: 2)
  static Future<void> show(BuildContext context, {required List<String> imageUrls, int initialIndex = 0}) {
    return showDialog(
      context: context,
      barrierColor: AppTheme.black.withValues(alpha: 0.54), // 반투명 배경
      builder: (_) => ImageViewerPopup(imageUrls: imageUrls, initialIndex: initialIndex),
    );
  }

  @override
  State<ImageViewerPopup> createState() => _ImageViewerPopupState();
}

class _ImageViewerPopupState extends State<ImageViewerPopup> {
  late int _current; // 현재 표시 중인 이미지 인덱스

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
  }

  // 이전 이미지로 이동 (첫 번째 이미지에서는 동작 안 함)
  void _prev() {
    if (_current > 0) setState(() => _current--);
  }

  // 다음 이미지로 이동 (마지막 이미지에서는 동작 안 함)
  void _next() {
    if (_current < widget.imageUrls.length - 1) setState(() => _current++);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(), // 키보드 입력을 받기 위해 포커스 요청
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) _prev();
          if (event.logicalKey == LogicalKeyboardKey.arrowRight) _next();
          if (event.logicalKey == LogicalKeyboardKey.escape) Navigator.of(context).pop(); // ESC로 닫기
        }
      },
      // 배경(어두운 영역) 탭 시 팝업 닫기
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Material(
          color: AppTheme.transparent,
          child: Center(
            child: GestureDetector(
              onTap: () {}, // 이미지 영역 탭은 닫기 방지 (이벤트 전파 차단)
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9, maxHeight: MediaQuery.of(context).size.height * 0.85),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 현재 이미지 표시
                    Image.network(
                      widget.imageUrls[_current],
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          width: 80,
                          height: 80,
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

                    // 이전(←) 버튼: 이미지가 2장 이상일 때만 표시
                    if (widget.imageUrls.length > 1)
                      Positioned(
                        left: 8,
                        child: _NavButton(icon: Icons.chevron_left, onTap: _current > 0 ? _prev : null),
                      ),

                    // 다음(→) 버튼
                    if (widget.imageUrls.length > 1)
                      Positioned(
                        right: 8,
                        child: _NavButton(icon: Icons.chevron_right, onTap: _current < widget.imageUrls.length - 1 ? _next : null),
                      ),

                    // 우상단 닫기(X) 버튼
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(color: AppTheme.black.withValues(alpha: 0.54), shape: BoxShape.circle),
                          child: const Icon(Icons.close, color: AppTheme.white, size: 18),
                        ),
                      ),
                    ),

                    // 하단 페이지 인디케이터 (현재 이미지는 넓은 점, 나머지는 작은 점)
                    if (widget.imageUrls.length > 1)
                      Positioned(
                        bottom: 12,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(widget.imageUrls.length, (i) {
                            return Container(
                              width: i == _current ? 20 : 8, // 현재 이미지는 넓은 점
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                color: i == _current ? AppTheme.white : AppTheme.white.withValues(alpha: 0.54),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 이미지 뷰어 내부의 좌/우 이동 버튼
// onTap이 null이면 비활성화 상태(흐린 색상)로 표시됩니다.
class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap; // null이면 비활성화

  const _NavButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          // 활성화: 반투명 검정, 비활성화: 더 연한 반투명 검정
          color: onTap != null ? AppTheme.black.withValues(alpha: 0.54) : AppTheme.black.withValues(alpha: 0.26),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: onTap != null ? AppTheme.white : AppTheme.white.withValues(alpha: 0.38), size: 24),
      ),
    );
  }
}
