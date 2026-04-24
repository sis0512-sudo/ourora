// 홈 화면 하단의 CTA(Call-To-Action) 섹션.
// 배경 이미지에 패럴랙스(시차) 스크롤 효과가 적용됩니다.
// 패럴랙스: 사용자가 스크롤할 때 배경 이미지가 콘텐츠보다 느리게 이동하는 효과
import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/responsive.dart';

class FooterCtaSection extends StatefulWidget {
  const FooterCtaSection({super.key, required this.scrollController});

  // 부모(HomeScreen)의 스크롤 컨트롤러를 받아 스크롤 위치를 감지합니다.
  final ScrollController scrollController;

  @override
  State<FooterCtaSection> createState() => _FooterCtaSectionState();
}

class _FooterCtaSectionState extends State<FooterCtaSection> {
  final GlobalKey _key = GlobalKey(); // 이 위젯의 화면 위치를 계산하기 위한 키
  double _parallaxOffset = 0;        // 현재 배경 이미지의 수직 오프셋(이동량)

  static const double _visibleHeight = 510;  // 섹션의 실제 표시 높이 (px)
  static const double _extraHeight = 1500;   // 배경 이미지의 추가 높이 (패럴랙스 범위)

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
    // 첫 프레임 렌더링 완료 후 초기 오프셋 계산
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  // 스크롤 이벤트마다 패럴랙스 오프셋을 재계산하여 배경 이미지 위치를 업데이트합니다.
  void _onScroll() {
    final ctx = _key.currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;

    final screenHeight = MediaQuery.of(context).size.height;
    // 뷰포트 기준으로 이 섹션의 상단이 얼마나 떨어져 있는지 계산
    final sectionTopInViewport = box.localToGlobal(Offset.zero).dy;

    // t=1: 섹션이 화면 아래에서 막 진입 → 배경 하단 표시
    // t=0: 섹션이 화면 위로 사라짐 → 배경 상단 표시
    final t = (sectionTopInViewport + _visibleHeight) / (screenHeight + _visibleHeight);
    final offset = (_extraHeight * t).clamp(0.0, _extraHeight);

    // 변화량이 0.5px 이상일 때만 setState 호출 (불필요한 리빌드 방지)
    if ((offset - _parallaxOffset).abs() > 0.5) {
      setState(() => _parallaxOffset = offset);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return SizedBox(
      key: _key,
      width: double.infinity,
      height: isMobile ? 350 : _visibleHeight,
      child: ClipRect( // 섹션 영역 밖으로 나가는 배경 이미지를 잘라냅니다.
        child: Stack(
          children: [
            // 배경 이미지 — 실제 높이보다 크게, 패럴랙스 오프셋으로 위치 이동
            isMobile
                ? Image.asset(
                    'assets/images/footer_cta_background.webp',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : Positioned(
                    top: -_parallaxOffset, // 스크롤에 따라 위치가 변하는 패럴랙스 오프셋
                    left: 0,
                    right: 0,
                    height: _visibleHeight + _extraHeight, // 섹션 높이 + 패럴랙스 여유 공간
                    child: Image.asset(
                      'assets/images/footer_cta_background.webp',
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),

            // 텍스트 + 버튼 오버레이
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'YOUR OWN LIGHT',
                      style: TextStyle(
                        fontFamily: 'ArialBlack',
                        fontSize: isMobile ? 40 : 70,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.white,
                        letterSpacing: 4,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'MAKE YOU SHINE IN THE WORLD',
                      style: const TextStyle(fontFamily: 'ArialBlack', fontSize: 24, fontWeight: FontWeight.w400, color: AppTheme.white, letterSpacing: 1.2),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.white,
                        side: const BorderSide(color: AppTheme.white, width: 1.5),
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      ),
                      child: Text('Read More >>', style: const TextStyle(fontSize: 16, letterSpacing: 0.5)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
