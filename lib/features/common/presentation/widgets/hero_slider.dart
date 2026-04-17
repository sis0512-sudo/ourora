import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/constants.dart';

class HeroSlider extends StatefulWidget {
  const HeroSlider({super.key});

  @override
  State<HeroSlider> createState() => _HeroSliderState();
}

class _HeroSliderState extends State<HeroSlider> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => _next());
  }

  void _resetTimer() {
    _timer?.cancel();
    _startTimer();
  }

  void _next() {
    setState(() => _currentIndex = (_currentIndex + 1) % AppConstants.heroSlides.length);
  }

  void _prev() {
    setState(() => _currentIndex = (_currentIndex - 1 + AppConstants.heroSlides.length) % AppConstants.heroSlides.length);
  }

  @override
  Widget build(BuildContext context) {
    const double height = 694;
    final slide = AppConstants.heroSlides[_currentIndex];

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
            child: _HeroSlide(
              key: ValueKey(_currentIndex),
              image: slide.image,
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
              child: _ArrowButton(icon: Icons.chevron_left, onTap: () { _prev(); _resetTimer(); }),
            ),
          ),
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: _ArrowButton(icon: Icons.chevron_right, onTap: () { _next(); _resetTimer(); }),
            ),
          ),
          // 하단 도트 인디케이터
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: AppConstants.heroSlides.asMap().entries.map((entry) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == entry.key ? Colors.white : Colors.white38,
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

class _HeroSlide extends StatelessWidget {
  final String image;
  final String subtitle;
  final String title;
  final MainAxisAlignment mainAxisAlignment;

  const _HeroSlide({
    super.key,
    required this.image,
    required this.subtitle,
    required this.title,
    this.mainAxisAlignment = MainAxisAlignment.end,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(image, fit: BoxFit.cover),
        Center(
          child: Column(
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 96),
              Text(subtitle, style: AppTheme.heroSubtitle(), textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text(title, style: AppTheme.heroTitle(), textAlign: TextAlign.center),
              const SizedBox(height: 96),
            ],
          ),
        ),
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(width: 48, height: 48, child: Icon(icon, color: Colors.white, size: 48)),
    );
  }
}
