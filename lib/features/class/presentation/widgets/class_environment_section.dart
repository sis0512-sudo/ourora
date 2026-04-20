import 'package:flutter/material.dart';
import 'package:ourora/features/common/presentation/widgets/bullet_list.dart';

class ClassEnvironmentSection extends StatelessWidget {
  const ClassEnvironmentSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80, bottom: 40),
      child: Column(
        children: [
          BulletList(title: '수업 환경', items: ['작업대 : 작업실 2인용 3대, 기계실 2인용 1대, 1인용 2대, (필요시)확장테이블 1대', '기계실 장비 리스트']),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Image.asset('assets/images/machine_list.webp', width: double.maxFinite, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}
