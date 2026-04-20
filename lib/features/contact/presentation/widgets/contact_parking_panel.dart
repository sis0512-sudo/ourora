import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/title_widget.dart';

class ContactParkingPanel extends StatelessWidget {
  const ContactParkingPanel({super.key, this.titleStyle, this.bodyStyle});

  final TextStyle? titleStyle;
  final TextStyle? bodyStyle;

  @override
  Widget build(BuildContext context) {
    final bs = bodyStyle ?? AppTheme.contactBody();

    Widget bullet(String text) => Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: bs),
          Expanded(child: Text(text, style: bs)),
        ],
      ),
    );

    return Container(
      color: AppTheme.white,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(title: '주차 안내', isSubTitle: false),
          const SizedBox(height: 32),
          Text('공영주차장', style: bs),
          bullet('바로 앞 사거리 공유주차(약 50m) (평상시 약 1~2대 비어있음)'),
          bullet('신정4동길노상공영주차장(약 300m) : 서울 양천구 신정4동 1065'),
          bullet('신서 공영주차장(약 400m) : 서울 양천구 은행정로 42 신서고등학교'),
          const SizedBox(height: 20),
          Text('유료주차장', style: bs),
          bullet('보성팰리스(바로 뒷건물) : 서울 양천구 오목로 232'),
        ],
      ),
    );
  }
}
