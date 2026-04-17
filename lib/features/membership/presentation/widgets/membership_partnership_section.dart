import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/title_divider.dart';
import 'package:ourora/features/membership/presentation/widgets/membership_card.dart';

class MembershipPartnershipSection extends StatelessWidget {
  const MembershipPartnershipSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '협력 파트너십',
            style: TextStyle(fontFamily: 'BMHanna', fontSize: 24, color: AppTheme.black),
          ),
          TitleDivider(isSubTitle: true),
          const SizedBox(height: 20),
          Text(
            '개인 / 팀 단위의 작품 활동, 또는 공방 창업 및 사업준비를 위한 협력 파트너십입니다.',
            style: AppTheme.bodyKorean(),
          ),
          const SizedBox(height: 20),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MembershipCard(
                bgColor: AppTheme.black,
                title: '오로라에잇츠',
                subtitle: 'OURORA 8s',
                description:
                    '오로라공방의 지원을 받아 작품 활동을 하는 작가 그룹입니다.\n\n'
                    '오로라에잇 수료자 또는 외부 공방/기관의 중급이상 수료자 중, 기존 멤버에 의해 추천을 받아 선정됩니다. ​다양한 작품 활동 및 전시 등을 개인 / 팀 단위로 진행합니다.',
              ),
              MembershipCard(
                bgColor: AppTheme.black,
                title: '오로라펠로우',
                subtitle: 'OURORA FELLOW',
                description:
                    '공방창업 및 관련 사업을 준비하는 예비사업 멤버입니다.\n\n'
                    '오로라에잇 수료자 중, 높은 기술력을 갖춘 분을 중심으로 선발과정을 거쳐 선정되며, 개인 사업준비를 위한 상품개발(샘플링)은 물론, 조교 또는 강의를 할 수 있고, 상품 판매, 주문제작 등 공방에서 상업적 활동을 하실 수 있는 파트너입니다.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
