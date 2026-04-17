import 'package:flutter/material.dart';

class FooterCtaSection extends StatefulWidget {
  const FooterCtaSection({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<FooterCtaSection> createState() => _FooterCtaSectionState();
}

class _FooterCtaSectionState extends State<FooterCtaSection> {
  final GlobalKey _key = GlobalKey();
  double _parallaxOffset = 0;

  static const double _visibleHeight = 510;
  static const double _extraHeight = 400;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final ctx = _key.currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;

    final screenHeight = MediaQuery.of(context).size.height;
    final sectionTopInViewport = box.localToGlobal(Offset.zero).dy;

    // t=1: 섹션이 화면 아래에서 막 진입 → 배경 하단 표시
    // t=0: 섹션이 화면 위로 사라짐 → 배경 상단 표시
    final t = (sectionTopInViewport + _visibleHeight) / (screenHeight + _visibleHeight);
    final offset = (_extraHeight * t).clamp(0.0, _extraHeight);

    if ((offset - _parallaxOffset).abs() > 0.5) {
      setState(() => _parallaxOffset = offset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: _key,
      width: double.infinity,
      height: _visibleHeight,
      child: ClipRect(
        child: Stack(
          children: [
            // 배경 이미지 — 실제 높이보다 크게, 패럴랙스 오프셋으로 위치 이동
            Positioned(
              top: -_parallaxOffset,
              left: 0,
              right: 0,
              height: _visibleHeight + _extraHeight,
              child: Image.asset('assets/images/footer_cta_background.webp', fit: BoxFit.cover, alignment: Alignment.center),
            ),

            // 텍스트 + 버튼
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'YOUR OWN LIGHT',
                    style: const TextStyle(fontFamily: 'Arial Black', color: Colors.white, fontSize: 70, fontWeight: FontWeight.bold, height: 1.2),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'MAKE YOU SHINE IN THE WORLD',
                    style: const TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 0.05 * 24, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 1.5),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    ),
                    child: const Text('Read More >>', style: TextStyle(fontSize: 16, letterSpacing: 0.5)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
