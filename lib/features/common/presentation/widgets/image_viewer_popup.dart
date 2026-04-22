import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ourora/config/theme.dart';

class ImageViewerPopup extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImageViewerPopup({super.key, required this.imageUrls, this.initialIndex = 0});

  static Future<void> show(BuildContext context, {required List<String> imageUrls, int initialIndex = 0}) {
    return showDialog(
      context: context,
      barrierColor: AppTheme.black.withValues(alpha: 0.54),
      builder: (_) => ImageViewerPopup(imageUrls: imageUrls, initialIndex: initialIndex),
    );
  }

  @override
  State<ImageViewerPopup> createState() => _ImageViewerPopupState();
}

class _ImageViewerPopupState extends State<ImageViewerPopup> {
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
  }

  void _prev() {
    if (_current > 0) setState(() => _current--);
  }

  void _next() {
    if (_current < widget.imageUrls.length - 1) setState(() => _current++);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) _prev();
          if (event.logicalKey == LogicalKeyboardKey.arrowRight) _next();
          if (event.logicalKey == LogicalKeyboardKey.escape) Navigator.of(context).pop();
        }
      },
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Material(
          color: AppTheme.transparent,
          child: Center(
            child: GestureDetector(
              onTap: () {}, // 이미지 영역 탭은 닫기 방지
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9, maxHeight: MediaQuery.of(context).size.height * 0.85),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 이미지
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

                    // 좌측 버튼
                    if (widget.imageUrls.length > 1)
                      Positioned(
                        left: 8,
                        child: _NavButton(icon: Icons.chevron_left, onTap: _current > 0 ? _prev : null),
                      ),

                    // 우측 버튼
                    if (widget.imageUrls.length > 1)
                      Positioned(
                        right: 8,
                        child: _NavButton(icon: Icons.chevron_right, onTap: _current < widget.imageUrls.length - 1 ? _next : null),
                      ),

                    // 닫기 버튼
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

                    // 페이지 인디케이터
                    if (widget.imageUrls.length > 1)
                      Positioned(
                        bottom: 12,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(widget.imageUrls.length, (i) {
                            return Container(
                              width: i == _current ? 20 : 8,
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

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _NavButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: onTap != null ? AppTheme.black.withValues(alpha: 0.54) : AppTheme.black.withValues(alpha: 0.26),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: onTap != null ? AppTheme.white : AppTheme.white.withValues(alpha: 0.38), size: 24),
      ),
    );
  }
}
