import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/constants.dart';
import 'package:ourora/features/common/utils/responsive.dart';

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
    final isMobile = Responsive.isMobileDevice;

    double height = isMobile ? 580 : 694;
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
      fit: StackFit.expand,
      children: [
        Image.asset(imagePath, fit: BoxFit.cover, alignment: Alignment.center, width: double.infinity, height: double.infinity),
        Center(
          child: Column(
            mainAxisAlignment: mainAxisAlignment,
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
