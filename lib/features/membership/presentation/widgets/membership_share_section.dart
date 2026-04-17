import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/title_divider.dart';
import 'package:ourora/features/membership/presentation/widgets/membership_card.dart';

class MembershipShareSection extends StatelessWidget {
  const MembershipShareSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '공방 쉐어(share) 멤버십',
            style: TextStyle(fontFamily: 'BMHanna', fontSize: 24, color: AppTheme.black),
          ),
          TitleDivider(isSubTitle: true),
          const SizedBox(height: 20),
          Text(
            '클래스 이수 후, 지속적인 개인 자유작업, 취미 목공, 작품활동, 기술 및 디자인 연구 등을 위한 공방 쉐어(share)입니다.',
            style: AppTheme.bodyKorean(),
          ),
          const SizedBox(height: 20),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MembershipCard(
                bgColor: Color(0xFFFF6161),
                title: '자유반',
                subtitle: 'FREE PASS MEMBERSHIP',
                description:
                    '정규과정 수료자 분들의 지속적인 취미활동을 위한 자유제작반 멤버십니다.\n'
                    '\n'
                    '매주 정해진 요일(주 1~2회)에 시간제한 없이 자유롭게 공방을 이용할 수 있습니다.\n'
                    '(주문제작, 판매상품 제작 등 ​상업적 목적의 이용은 불가능합니다)',
              ),
              MembershipCard(
                bgColor: Color(0xFFB08484),
                title: '연구반',
                subtitle: 'RESEARCH & TRAINING MEMBERSHIP',
                description:
                    '오로라공방의 전문가반 클래스 \'오로라에잇(OURORA 8)\' 과정이수자를 위한 멤버십입니다.\n'
                    '\n'
                    '수료를 위한 작품 제작. 디자인 연구 등의 작업을 진행할 수 있으며, 이용료 외 별도의 추가 수업료 없이, 재수강이나 코칭을 받을 수 있습니다.\n'
                    '365일 공방오픈 시간내 공방 자유이용(11:00~23:00)\n(기계사용은 22:00까지 가능)',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
