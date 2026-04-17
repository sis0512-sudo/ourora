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
      child: const Column(children: [_HeaderSection(), _ShareMembershipSection(), _PartnershipSection(), _PartnerCardsSection(), SizedBox(height: 80)]),
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
      padding: const EdgeInsets.symmetric(vertical: 16),
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
              _ShareCard(
                bgColor: Color(0xFFFF6161),
                title: '자유반',
                subtitle: 'FREE PASS MEMBERSHIP',
                description:
                    '정규과정 수료자 분들의 지속적인 취미활동을 위한 자유제작반 멤버십니다.\n'
                    '\n'
                    '매주 정해진 요일(주 1~2회)에 시간제한 없이 자유롭게 공방을 이용할 수 있습니다.\n'
                    '(주문제작, 판매상품 제작 등 ​상업적 목적의 이용은 불가능합니다)',
              ),
              _ShareCard(
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

class _ShareCard extends StatelessWidget {
  const _ShareCard({required this.bgColor, required this.title, required this.subtitle, required this.description});

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
      padding: const EdgeInsets.fromLTRB(0, 44, 0, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '협력 파트너십',
            style: const TextStyle(fontFamily: 'BMHanna', fontSize: 24, fontWeight: FontWeight.w700, color: AppTheme.black),
          ),
          const SizedBox(height: 8),
          Container(width: 36, height: 4, color: AppTheme.black),
          const SizedBox(height: 20),
          Text(
            '오로라스튜디오와 함께 성장하고 싶은 분들을 위한 파트너십 프로그램입니다.\n'
            '공방 공간과 장비를 활용하여 자신만의 프로젝트를 진행하거나,\n'
            '오로라스튜디오의 네트워크를 통해 다양한 협력 기회를 만들어 나갈 수 있습니다.',
            style: AppTheme.bodyKorean(),
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
    return const Padding(
      padding: EdgeInsets.fromLTRB(0, 11, 0, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PartnerCard(
                  title: '오로라에이터',
                  subtitle: 'OURORA 8s',
                  description:
                      '월 8회 공방 이용이 가능한 입문 파트너십입니다.\n'
                      '공방의 모든 기계와 공구를 사용할 수 있으며,\n'
                      '정기 미팅을 통해 다른 메이커들과 교류할 수 있습니다.',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _PartnerCard(
                  title: '오로라펠로우',
                  subtitle: 'OURORA FELLOW',
                  description:
                      '오로라스튜디오의 핵심 파트너 멤버십입니다.\n'
                      '공방을 무제한으로 이용할 수 있으며,\n'
                      '개인 작업 공간과 수납 공간이 제공됩니다.\n'
                      '오로라스튜디오 브랜드와의 협업 기회가 주어집니다.',
                ),
              ),
            ],
          ),
          SizedBox(height: 48),
          _CommonTermsSection(),
        ],
      ),
    );
  }
}

class _PartnerCard extends StatelessWidget {
  const _PartnerCard({required this.title, required this.subtitle, required this.description});

  final String title;
  final String subtitle;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.black,
      padding: const EdgeInsets.all(32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontFamily: 'BMHanna', fontSize: 24, fontWeight: FontWeight.w700, color: AppTheme.white),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.5, color: Colors.white54),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 80, color: Colors.white24, margin: const EdgeInsets.symmetric(horizontal: 20)),
          Expanded(
            flex: 3,
            child: Text(
              description,
              style: const TextStyle(fontFamily: 'NanumGothic', fontSize: 13, color: AppTheme.white, height: 1.8),
            ),
          ),
        ],
      ),
    );
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
          style: const TextStyle(fontFamily: 'BMHanna', fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.black),
        ),
        const SizedBox(height: 8),
        Container(width: 36, height: 4, color: AppTheme.black),
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
