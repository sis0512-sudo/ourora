import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutFidpSection extends StatelessWidget {
  const AboutFidpSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      padding: EdgeInsets.symmetric(vertical: 100, horizontal: 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('F+I+D+P', style: AppTheme.aboutFidpTitle(), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Container(width: double.infinity, height: 1, color: AppTheme.borderGray),
              const SizedBox(height: 28),
              Text(
                '오로라공방은 가구(Furniture)와 IT(Information Technology), 그리고 디자인(Design)과 사람(People)이라는 4가지 주제들과 함께 합니다.',
                style: AppTheme.bodyKorean().copyWith(height: 1.6),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              OutlinedButton(
                onPressed: () => launchUrl(Uri.parse('https://www.ourorastudio.com/fidp'), mode: LaunchMode.externalApplication),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
                  foregroundColor: AppTheme.white,
                  backgroundColor: AppTheme.textGray,
                  surfaceTintColor: Colors.transparent,
                  overlayColor: Colors.transparent,
                ),
                child: Text('더 읽어보기 >>', style: AppTheme.fidpButton()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
