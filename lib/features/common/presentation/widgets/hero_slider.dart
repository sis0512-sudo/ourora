// 홈 화면 최상단에 표시되는 전체 화면 이미지 슬라이더 위젯.
// 4장의 이미지를 10초 간격으로 자동 전환하며, 좌우 화살표와 하단 도트 인디케이터를 제공합니다.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/responsive.dart';

// 슬라이드 하나의 데이터(자막, 제목, 이미지 경로, 텍스트 정렬)를 담는 데이터 클래스
class HeroSlide {
  final String subtitle;    // 이탤릭체 소제목
  final String title;       // 굵은 메인 제목
  final String imagePath;   // 에셋 이미지 경로
  final MainAxisAlignment mainAxisAlignment; // 텍스트 수직 위치

  const HeroSlide({required this.subtitle, required this.title, required this.imagePath, this.mainAxisAlignment = MainAxisAlignment.end});
}

class HeroSlider extends StatefulWidget {
  const HeroSlider({super.key});

  @override
  State<HeroSlider> createState() => _HeroSliderState();
}

class _HeroSliderState extends State<HeroSlider> {
  int _currentIndex = 0; // 현재 표시 중인 슬라이드 인덱스
  Timer? _timer;         // 자동 전환 타이머

  // Hero 슬라이더 텍스트
  List<HeroSlide> heroSlides = [
    HeroSlide(
      subtitle: 'All good things which exist are',
      title: 'THE FRUITS OF\nORIGINALITY',
      imagePath: 'assets/images/hero_1_compressed.webp',
      mainAxisAlignment: MainAxisAlignment.end,
    ),
    HeroSlide(subtitle: 'Make', title: 'IT HAPPEN', imagePath: 'assets/images/hero_2_compressed.webp', mainAxisAlignment: MainAxisAlignment.start),
    HeroSlide(subtitle: 'Show me', title: 'YOUR STORY', imagePath: 'assets/images/hero_3_compressed.webp', mainAxisAlignment: MainAxisAlignment.start),
    HeroSlide(subtitle: 'It\'s', title: 'YOUR PLACE', imagePath: 'assets/images/hero_4_compressed.webp', mainAxisAlignment: MainAxisAlignment.center),
  ];

  @override
  void initState() {
    super.initState();
    _startTimer(); // 위젯 생성 시 자동 전환 시작
  }

  @override
  void dispose() {
    _timer?.cancel(); // 위젯 소멸 시 타이머 취소
    super.dispose();
  }

  // 10초마다 다음 슬라이드로 이동하는 타이머를 시작합니다.
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => _next());
  }

  // 사용자가 화살표를 클릭했을 때 타이머를 초기화합니다. (자동 전환 간격 리셋)
  void _resetTimer() {
    _timer?.cancel();
    _startTimer();
  }

  // 다음 슬라이드로 이동 (마지막에서 첫 번째로 순환)
  void _next() {
    setState(() => _currentIndex = (_currentIndex + 1) % heroSlides.length);
  }

  // 이전 슬라이드로 이동 (첫 번째에서 마지막으로 순환)
  void _prev() {
    setState(() => _currentIndex = (_currentIndex - 1 + heroSlides.length) % heroSlides.length);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    double height = isMobile ? 580 : 694;
    final slide = heroSlides[_currentIndex];

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          // AnimatedSwitcher: 슬라이드 전환 시 FadeTransition(페이드 인/아웃) 애니메이션 적용
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
            child: _HeroSlide(
              key: ValueKey(_currentIndex), // 키가 바뀌면 AnimatedSwitcher가 전환 애니메이션 실행
              imagePath: slide.imagePath,
              subtitle: slide.subtitle,
              title: slide.title,
              mainAxisAlignment: slide.mainAxisAlignment,
            ),
          ),
          // 좌우 화살표
          Positioned(
            left: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: _ArrowButton(
                icon: Icons.chevron_left,
                onTap: () {
                  _prev();
                  _resetTimer();
                },
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: _ArrowButton(
                icon: Icons.chevron_right,
                onTap: () {
                  _next();
                  _resetTimer();
                },
              ),
            ),
          ),
          // 하단 도트 인디케이터: 현재 슬라이드 위치를 점으로 표시
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: heroSlides.asMap().entries.map((entry) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // 현재 슬라이드는 불투명 흰색, 나머지는 반투명 흰색
                    color: _currentIndex == entry.key ? AppTheme.white : AppTheme.white.withValues(alpha: 0.38),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// 슬라이드 하나의 실제 화면: 배경 이미지 위에 자막과 제목 텍스트를 오버레이합니다.
class _HeroSlide extends StatelessWidget {
  final String imagePath;
  final String subtitle;
  final String title;
  final MainAxisAlignment mainAxisAlignment;

  const _HeroSlide({super.key, required this.imagePath, required this.subtitle, required this.title, this.mainAxisAlignment = MainAxisAlignment.end});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return Stack(
      fit: StackFit.expand, // Stack이 부모 크기를 꽉 채웁니다.
      children: [
        // 전체 화면을 덮는 배경 이미지
        Image.asset(imagePath, fit: BoxFit.cover, alignment: Alignment.center, width: double.infinity, height: double.infinity),
        // 이미지 위에 텍스트 오버레이
        Center(
          child: Column(
            mainAxisAlignment: mainAxisAlignment, // 텍스트 수직 위치 (위/중간/아래)
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 96),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Playfair',
                  fontSize: isMobile ? 20 : 26,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(fontFamily: 'Raleway', fontSize: isMobile ? 40 : 60, fontWeight: FontWeight.w700, color: AppTheme.white, height: 1.1),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 96),
            ],
          ),
        ),
      ],
    );
  }
}

// 좌우 이동 화살표 버튼
class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(width: 48, height: 48, child: Icon(icon, color: AppTheme.white, size: 48)),
    );
  }
}
