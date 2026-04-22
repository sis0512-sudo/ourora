import 'package:flutter/material.dart';
import 'package:ourora/features/common/presentation/widgets/bullet_list.dart';
import 'package:ourora/features/common/utils/responsive.dart';

class MembershipCommonTermsSection extends StatelessWidget {
  const MembershipCommonTermsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;
    return Padding(
      padding: isMobile ? const EdgeInsetsGeometry.symmetric(horizontal: 32) : EdgeInsets.zero,
      child: BulletList(
        title: '공통 운영사항',
        items: const [
          TextSpan(text: '멤버십 이용은 사전 신청 후 심사를 통해 승인됩니다.'),
          TextSpan(text: '공방 이용 시 안전 교육을 이수하셔야 합니다.'),
          TextSpan(text: '공방 내 모든 기계 및 공구는 안전 수칙에 따라 사용해야 합니다.'),
          TextSpan(text: '타인의 작업물 및 재료에 대한 무단 사용을 금합니다.'),
          TextSpan(text: '공방 이용 후에는 반드시 청소 및 정리정돈을 해주셔야 합니다.'),
        ],
      ),
    );
  }
}
