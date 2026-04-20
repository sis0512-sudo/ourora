import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/title_widget.dart';

class MembershipCommonTermsSection extends StatelessWidget {
  const MembershipCommonTermsSection({super.key});

  static const _items = [
    '멤버십 이용은 사전 신청 후 심사를 통해 승인됩니다.',
    '공방 이용 시 안전 교육을 이수하셔야 합니다.',
    '공방 내 모든 기계 및 공구는 안전 수칙에 따라 사용해야 합니다.',
    '타인의 작업물 및 재료에 대한 무단 사용을 금합니다.',
    '공방 이용 후에는 반드시 청소 및 정리정돈을 해주셔야 합니다.',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(title: '공통 이용사항', isSubTitle: true),
        const SizedBox(height: 20),
        ..._items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 14, color: AppTheme.black, height: 1.8)),
                Expanded(child: Text(item, style: AppTheme.bodyKorean())),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
