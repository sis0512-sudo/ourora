import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutProfileSection extends StatelessWidget {
  const AboutProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _ProfileContent();
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.black,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: AppConstants.windowMaxWidth),
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CHIEF',
            style: TextStyle(
              fontFamily: 'sans-serif',
              fontSize: 46,
              fontWeight: FontWeight.bold,
              letterSpacing: 11.5,
              color: AppTheme.white.withValues(alpha: 0.8),
            ),
          ),
          Text(
            '공방장 프로필',
            style: TextStyle(
              fontFamily: 'Noto Sans KR',
              fontSize: 17,
              fontWeight: FontWeight.normal,
              letterSpacing: 4,
              color: AppTheme.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 32),
          _Section(
            title: 'EDUCATION',
            items: const [_TextItem('서울시 남부기술교육원 가구디자인 졸업'), _TextItem('홍익대학교 인터랙션디자인 졸업'), _TextItem('한국공예·디자인문화진흥원 & 국민대학교 2021공예매개인력양성 \'공예 에듀케이터\' 과정 수료')],
          ),
          _Section(
            title: 'EXHIBITION & AWARD',
            items: const [
              _TextItem('2025 K-DESIGN AWARD FINALIST'),
              _TextItem('2024 K-DESIGN AWARD FINALIST'),
              _TextItem('2023 대한민국디자인전람회 특선'),
              _TextItem('2023 가구디자인 전시 \'목가구의 아름다움\', 서울생활문화센터 신도림, 서울'),
              _TextItem('2022 가구디자인 전시 \'木錄. 木LOG. 목록 22\', MWG갤러리, 서울'),
              _TextItem('2021 OURORA 8 POP-UP EXHIBITION \'Untitled\', K-핸드메이드페어 2021, 코엑스'),
              _TextItem('2021 오로라공방 온라인 과제전, OURORA Feed'),
              _TextItem('2020 INTERNATIONAL GOOD DESIGN EXHIBITION, Museo del Design, 꼬모, 이탈리아'),
              _TextItem('2020 공예트렌드페어 전시, 코엑스'),
              _TextItem('2019 A\'DESIGN AWARD & COMPETITION 2018-2019, 은상(Silver), 밀라노, 이탈리아'),
              _TextItem('2018 가구디자인 전시 \'epilogue\', 고리, 서울'),
              _TextItem('2018 대한민국 가구디자인 공모전, 기업상(한샘), 경기도'),
              _TextItem('2018 한국국제가구&인테리어산업대전(KOFURN) 전시, 킨텍스'),
              _TextItem('2015 미디어아트 전시 \'비\', 문화창조융합센터(CCCC)'),
            ],
          ),
          _Section(
            title: 'PRESS',
            items: [
              _LinkItem(label: 'Design Diffusion (2020)', url: 'https://www.designdiffusion.com/en/2020/02/17/a-design-award-competition-last-call/'),
              _LinkItem(
                label: 'Design Diffusion (2019)',
                url: 'https://www.designdiffusion.com/en/2019/08/12/a-design-award-competition-the-winners-2018-2019/',
              ),
              _LinkItem(label: 'IdN Magazine (2020)', url: 'https://www.idnworld.com/creators/ADesignAward-ExtendedDeadline20'),
              _LinkItem(label: 'IdN Magazine (2019)', url: 'https://www.idnworld.com/creators/ADesignAward-Winners19'),
              _LinkItem(label: 'Design Milk (2019)', url: 'https://design-milk.com/the-a-design-awards-competition-presents-its-2019-winners/'),
            ],
          ),
          _Section(
            title: 'PATENT',
            items: const [
              _TextItem('책상가구 디자인 (30-2018-0037398, 2018.08.13)'),
              _TextItem('기능 제한이 가능한 이동단말 및 이의 기능 제한 시스템 (10-2015-0050980, 2015.04.10)'),
              _TextItem('임베디드 디바이스상에서 플랫폼 기반 어플리케이션의 품질테스트 결과 예측 시스템 및 그 방법(1020060049826, 2006.06.02)'),
            ],
          ),
          _Section(title: 'PREVIOUS WORKS', items: const [_TextItem('사용자 경험(UX : User Experience) 디자이너'), _TextItem('컴퓨터 소프트웨어 프로그래머')]),
        ],
          ),
        ),
      ),
    );
  }
}

abstract class _ProfileItem {
  const _ProfileItem();
  Widget build(BuildContext context);
}

class _TextItem extends _ProfileItem {
  final String text;
  const _TextItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTheme.profileText());
  }
}

class _LinkItem extends _ProfileItem {
  final String label;
  final String url;
  const _LinkItem({required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$label - ', style: AppTheme.profileText()),
        GestureDetector(
          onTap: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
          child: Text(
            url,
            style: TextStyle(
              fontFamily: 'Noto Sans KR',
              fontSize: 10,
              height: 2.5,
              color: AppTheme.white.withValues(alpha: 0.5),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<_ProfileItem> items;

  const _Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Noto Sans KR',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              height: 2.5,
              letterSpacing: 0.14,
              color: AppTheme.white.withValues(alpha: 0.8),
            ),
          ),
          ...items.map((item) => item.build(context)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
