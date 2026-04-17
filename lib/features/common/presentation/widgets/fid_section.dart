import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/constants.dart';

class FidSection extends StatelessWidget {
  const FidSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: Column(
            children: [
              Text(
                '오로라 공방은?',
                style: const TextStyle(fontFamily: 'BMHanna', fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: 4, color: AppTheme.darkBg),
              ),
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 3,
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppTheme.darkBg, width: 3)),
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                height: 240,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: AppConstants.fidItems.map((item) {
                    return SizedBox(
                      width: 245,
                      child: _FidItem(letter: item['letter']!, title: item['title']!, desc: item['desc']!),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 48),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
                onPressed: () {},
                child: Text('Read More >>', style: AppTheme.navItem()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FidItem extends StatelessWidget {
  final String letter;
  final String title;
  final String desc;

  const _FidItem({required this.letter, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            letter,
            style: const TextStyle(fontFamily: 'BMHanna', fontSize: 70, fontWeight: FontWeight.bold, color: AppTheme.black, height: 1),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontFamily: 'Arial', fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.black, letterSpacing: 1),
          ),
          const SizedBox(height: 12),
          Text(
            desc,
            style: const TextStyle(fontFamily: 'NanumGothic', fontSize: 14, color: AppTheme.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
