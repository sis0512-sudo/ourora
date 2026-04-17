import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/nav_bar.dart';
import 'package:ourora/features/common/presentation/widgets/site_footer.dart';
import 'package:ourora/features/common/presentation/widgets/title_divider.dart';

class MembershipScreen extends StatelessWidget {
  const MembershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.black,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(delegate: NavBarDelegate(), pinned: true),
          const SliverToBoxAdapter(child: _MembershipBody()),
          const SliverToBoxAdapter(child: SiteFooter()),
        ],
      ),
    );
  }
}

class _MembershipBody extends StatelessWidget {
  const _MembershipBody();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 120),
      child: const Column(children: [_HeaderSection(), _ShareMembershipSection(), _PartnershipSection(), _PartnerCardsSection(), SizedBox(height: 200)]),
    );
  }
}

// ── Section 1: 오로라 멤버십 헤더 ────────────────────────────────────────────
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            '오로라 멤버십',
            style: const TextStyle(fontFamily: 'BMHanna', fontSize: 28, fontWeight: FontWeight.w400, color: AppTheme.black, letterSpacing: 2),
          ),
          const TitleDivider(),
          const SizedBox(height: 20),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset('assets/svgs/ourora_membership_logo.svg', height: 200),
                Text(
                  'OURORA MEMBERSHIP',
                  style: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.bold, color: AppTheme.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ── Section 2: 공방 쉐어(share) 멤버십 ───────────────────────────────────────
class _ShareMembershipSection extends StatelessWidget {
  const _ShareMembershipSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '공방 쉐어(share) 멤버십',
            style: const TextStyle(fontFamily: 'BMHanna', fontSize: 24, color: AppTheme.black),
          ),
          TitleDivider(isSubTitle: true),
          const SizedBox(height: 20),
          Text('클래스 이수 후, 지속적인 개인 자유작업, 취미 목공, 작품활동, 기술 및 디자인 연구 등을 위한 공방 쉐어(share)입니다.', style: AppTheme.bodyKorean()),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              MembershipScreenCard(
                bgColor: Color(0xFFFF6161),
                title: '자유반',
                subtitle: 'FREE PASS MEMBERSHIP',
                description:
                    '정규과정 수료자 분들의 지속적인 취미활동을 위한 자유제작반 멤버십니다.\n'
                    '\n'
                    '매주 정해진 요일(주 1~2회)에 시간제한 없이 자유롭게 공방을 이용할 수 있습니다.\n'
                    '(주문제작, 판매상품 제작 등 ​상업적 목적의 이용은 불가능합니다)',
              ),
              MembershipScreenCard(
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

class MembershipScreenCard extends StatelessWidget {
  const MembershipScreenCard({super.key, required this.bgColor, required this.title, required this.subtitle, required this.description});

  final Color bgColor;
  final String title;
  final String subtitle;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontFamily: 'BMHanna', fontSize: 35, color: AppTheme.white),
          ),
          const SizedBox(height: 40),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 150,
                child: Text(
                  subtitle,
                  style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.white),
                ),
              ),
              Container(width: 1, height: 100, color: AppTheme.white, margin: const EdgeInsets.symmetric(horizontal: 30)),
              Expanded(
                child: Text(
                  description,
                  style: const TextStyle(fontFamily: 'NanumGothic', fontSize: 16, color: AppTheme.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Section 3: 협력 파트너십 ─────────────────────────────────────────────────
class _PartnershipSection extends StatelessWidget {
  const _PartnershipSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '협력 파트너십',
            style: const TextStyle(fontFamily: 'BMHanna', fontSize: 24, color: AppTheme.black),
          ),
          TitleDivider(isSubTitle: true),
          const SizedBox(height: 20),
          Text('개인 / 팀 단위의 작품 활동, 또는 공방 창업 및 사업준비를 위한 협력 파트너십입니다.', style: AppTheme.bodyKorean()),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              MembershipScreenCard(
                bgColor: AppTheme.black,
                title: '오로라에잇츠',
                subtitle: 'OURORA 8s',
                description:
                    '오로라공방의 지원을 받아 작품 활동을 하는 작가 그룹입니다.\n\n'
                    '오로라에잇 수료자 또는 외부 공방/기관의 중급이상 수료자 중, 기존 멤버에 의해 추천을 받아 선정됩니다. ​다양한 작품 활동 및 전시 등을 개인 / 팀 단위로 진행합니다.',
              ),
              MembershipScreenCard(
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

// ── Section 4: 오로라에이터 / 오로라펠로우 카드 + 공통 이용사항 ───────────────
class _PartnerCardsSection extends StatelessWidget {
  const _PartnerCardsSection();

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_CommonTermsSection()]);
  }
}

// ── 공통 이용사항 ─────────────────────────────────────────────────────────────
class _CommonTermsSection extends StatelessWidget {
  const _CommonTermsSection();

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
        Text(
          '공통 이용사항',
          style: const TextStyle(fontFamily: 'BMHanna', fontSize: 24, color: AppTheme.black),
        ),
        TitleDivider(isSubTitle: true),
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
