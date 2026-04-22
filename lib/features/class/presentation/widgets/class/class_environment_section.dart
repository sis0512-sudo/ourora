import 'package:flutter/material.dart';
import 'package:ourora/features/common/presentation/widgets/bullet_list.dart';
import 'package:ourora/features/common/utils/responsive.dart';

class ClassEnvironmentSection extends StatelessWidget {
  const ClassEnvironmentSection({super.key});
  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return Padding(
      padding: isMobile ? EdgeInsets.zero : const EdgeInsets.only(top: 80, bottom: 40),
      child: Column(
        children: [
          Padding(
            padding: isMobile ? const EdgeInsets.symmetric(horizontal: 32, vertical: 40) : EdgeInsets.zero,
            child: BulletList(
              title: '수업 환경',
              items: const [
                TextSpan(text: '작업대 : 작업실 2인용 3대, 기계실 2인용 1대, 1인용 2대, (필요시)확장테이블 1대'),
                TextSpan(text: '기계실 장비 리스트'),
              ],
            ),
          ),
          Image.asset('assets/images/machine_list.webp', fit: BoxFit.fitWidth, height: isMobile ? null : 780),
        ],
      ),
    );
  }
}
