import 'package:flutter/material.dart';
import 'package:ourora/features/common/presentation/widgets/bullet_list.dart';

class ClassCommonGuidelinesSection extends StatelessWidget {
  const ClassCommonGuidelinesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: BulletList(
        title: '공통 안내',
        items: const [
          TextSpan(text: '모든 과정의 기간은 개인별 진도에 따라 달라질 수 있습니다.'),
          TextSpan(text: '필요시 보충 수업이 있을 수 있습니다.'),
          TextSpan(text: '수료 후 일부 중복되는 커리큘럼으로 등록시(예: 정규과정 중급반 이수 후 전문가반 등록시), 일정 할인을 제공합니다.'),
          TextSpan(text: '수업료 환불은 최초 1회 수업 전까지 100% 환불되며, 그 이후부터는 환불되지 않습니다.'),
        ],
      ),
    );
  }
}
