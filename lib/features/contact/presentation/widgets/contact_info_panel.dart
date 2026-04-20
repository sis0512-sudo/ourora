import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/title_widget.dart';
import 'package:ourora/features/common/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactInfoPanel extends StatelessWidget {
  const ContactInfoPanel({super.key, this.titleStyle, this.bodyStyle});

  final TextStyle? titleStyle;
  final TextStyle? bodyStyle;

  @override
  Widget build(BuildContext context) {
    final bs = bodyStyle ?? AppTheme.contactBody();

    return Container(
      color: AppTheme.white,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
      child: SelectionArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleWidget(title: '주소 / 연락처', isSubTitle: false),
            const SizedBox(height: 32),
            Text('주소 : 서울특별시 양천구 목동로21길 6', style: bs),
            Text('        지하1층 (우: 08022)', style: bs),
            Text('        (목동역(5호선) 8번출구에서 2분)', style: bs),
            const SizedBox(height: 8),
            Text('전화 : ${AppConstants.phone}', style: bs),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => launchUrl(Uri.parse('mailto:${AppConstants.email}')),
              child: Text.rich(
                TextSpan(
                  text: '이메일 : ',
                  style: bs,
                  children: [TextSpan(text: AppConstants.email, style: bs)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
