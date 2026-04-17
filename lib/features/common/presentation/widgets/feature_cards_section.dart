import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ourora/config/theme.dart';

enum FeatureCard {
  workshop(
    svgString: '''
<svg preserveAspectRatio="xMidYMid meet" data-bbox="50 0 100 200" xmlns="http://www.w3.org/2000/svg" viewBox="50 0 100 200" role="presentation" aria-hidden="true">
    <g>
        <path d="M97 0h7v33h-7V0z"></path>
        <path d="M75.2 36.9L66.6 22l6.5-3.6 8.5 14.8-6.4 3.7z"></path>
        <path d="M106 60.5v7.4c11 0 20.4 8.8 20.4 20.2 0 .1-.1 0-.1 0h7.4c.2-15-12-27.7-27.4-28-.1 0-.3.4-.3.4z"></path>
        <path d="M100 42.1c-27.6 0-50 22.3-50 49.9 0 8 1.9 15.9 5.6 23 2.5 5.7 5.8 11.2 9.3 16.3C69.3 138 73 143.6 73 150v33c0 2 1.6 2.2 3.7 2.2h7.5c.6 7 7.4 14.8 15.8 14.8s15.2-7.8 15.8-14.8h7.5c2.1 0 3.7 0 3.7-2.2v-33c0-6.4 3.8-12.1 8.2-18.7 3.7-5.3 6.9-10.9 9.4-16.8 3.5-7 5.4-14.7 5.4-22.5 0-27.5-22.4-49.9-50-49.9zm0 150.5c-4.3 0-7.8-4.4-8.3-7.4h16.7c-.6 3-4.1 7.4-8.4 7.4zm20-14.4H81v-10h39v10zm0-12H81v-7h39v7zm0-9H81v-6h39v6zm17.9-47.1h-.9v1.4c-2 5.6-4.9 10.7-8.3 15.7-4.7 7.1-8.4 13-8.7 22H80.7c-.3-9-4.5-14.9-9.1-22-3-4.7-6.5-9.4-8.5-15.2v-.3c-3-6-5.2-12.8-5.2-19.6 0-23.5 18.9-42.5 42.4-42.5s42.4 18.4 42.4 41.9c-.1 6.7-1.8 13.6-4.8 18.6z"></path>
        <path d="M125.3 36.9l-6.4-3.7 8.5-14.8 6.4 3.7-8.5 14.8z"></path>
    </g>
</svg>''',
    title: 'WORKSHOP',
    subtitle: '공방 소개',
    desc: '공방에 대한 소개와 문화, 그리고 추구하는 목표와 방향을 이야기합니다.',
    route: '/about',
  ),
  works(
    svgString: '''
<svg preserveAspectRatio="xMidYMid meet" data-bbox="26.525 22.625 146.957 154.875" viewBox="26.525 22.625 146.957 154.875" height="200" width="200" xmlns="http://www.w3.org/2000/svg" data-type="color" role="presentation" aria-hidden="true" aria-label=""><defs><style>#comp-k97hde3r1 svg [data-color="1"] {fill: #000000;}</style></defs>
    <g>
        <path d="M170.6 176.9c-.8.4-1.9.6-2.7.6-2.1 0-4-1-5-2.9l-25.8-49.8-70.6-6.1-29.3 55.9c-1 1.9-3.1 2.9-5 2.9-1 0-1.9-.2-2.7-.6-2.7-1.5-3.8-4.8-2.3-7.5l27.2-51.9-25.5-2.1s.4-5.2 1-11.5c.6-6.5 6.3-11.1 12.6-10.7l76.8 6.7c4.4.4 8 3.1 9.6 6.7-.6-1.9-.8-3.8-.4-5.6l13.6-68.6c1-6.5 7.1-10.7 13.4-9.6 6.3 1.3 11.3 2.1 11.3 2.1l-14.9 77-3.6 20.7 24.3 47.1c1.8 2.6.7 5.7-2 7.2z" fill="#414554" data-color="1"></path>
    </g>
</svg>''',
    title: 'WORKS',
    subtitle: '작품과 작업들',
    desc: '오로라공방 구성원분들이 제작한 작품들과 작업들을 소개합니다.',
    route: '/works',
  ),
  cls(
    svgString: '''
<svg preserveAspectRatio="none" data-bbox="0.064 21.9 199.636 155.7" xmlns="http://www.w3.org/2000/svg" viewBox="0.064 21.9 199.636 155.7" role="presentation" aria-hidden="true">
    <g>
        <path d="M6.4 170.2c.5.3 1.1.5 1.7.5.5 0 .9-.1 1.4-.3l39.3-17.2c.7-.3 1.2-.8 1.6-1.4l54.2-95.1c3.2-5.6 1.2-12.8-4.3-16L70.7 23.5c-2.7-1.6-5.9-2-9-1.2-3 .8-5.6 2.8-7.1 5.5l-54.1 95c-.4.6-.5 1.3-.4 2.1l4.7 42.7c.1 1.1.7 2 1.6 2.6zm14.4-38l50-87.6 11.3 6.5L32 138.8l-11.2-6.6zm-1.9-1.1l-11.4-6.7 49.9-87.6L69 43.5l-50.1 87.6zm24.4 17l-19.9 8.7-14-8.1-2.4-22 36.3 21.4zm2.1-1.4L34 140l50.1-87.7 11.3 6.6-50 87.8zM63.5 28.9c1.3-.3 2.6-.2 3.8.5l29.5 17.1c2.4 1.4 3.2 4.4 1.8 6.8L96.5 57 58.4 35l2-3.6c.7-1.3 1.8-2.2 3.1-2.5z"></path>
        <path d="M199.7 175.6v2H5.7v-2h194z"></path>
    </g>
</svg>''',
    title: 'CLASS',
    subtitle: '다양한 목공 수업',
    desc: '가구 디자인 및 목공 기술을 배울 수 있는 전문적인 수업에 참여하실 수 있습니다.',
    route: '/class',
  ),
  membership(
    svgString: '''
<svg preserveAspectRatio="xMidYMid meet" data-bbox="28.8 20 142.339 160" xmlns="http://www.w3.org/2000/svg" width="200" height="200" viewBox="28.8 20 142.339 160" data-type="color" role="presentation" aria-hidden="true" aria-label=""><defs><style>#comp-k97hde3z svg [data-color="1"] {fill: #000000;}</style></defs>
    <g>
        <path fill="#ff3644" d="M31.7 124.3c1.6 0 2.9-1.3 2.9-2.9V96h10.6c1.6 0 2.9-1.3 2.9-2.9s-1.3-2.9-2.9-2.9H34.6V67.1h10.6c1.6 0 2.9-1.3 2.9-2.9 0-1.6-1.3-2.9-2.9-2.9H34.6V25.8h32.7v66.1c0 1.6 1.3 2.9 2.9 2.9 1.6 0 2.9-1.3 2.9-2.9v-69c0-1.6-1.3-2.9-2.9-2.9H31.7c-1.6 0-2.9 1.3-2.9 2.9v98.5c0 1.6 1.3 2.9 2.9 2.9z" data-color="1"></path>
        <path fill="#ff3644" d="M127.3 95.4L107 82.5c-1-.6-2.3-.6-3.2.1L30 135.8c-.8.5-1.2 1.4-1.2 2.3v17.1c0 1.6 1.3 2.9 2.9 2.9h6.8v19c0 1.6 1.3 2.9 2.9 2.9s2.9-1.3 2.9-2.9v-21.8c0-1.6-1.3-2.9-2.9-2.9h-6.8v-12.7l71-51.2 18.6 11.8c1.3.8 3.1.5 4-.9.8-1.4.4-3.2-.9-4z" data-color="1"></path>
        <path fill="#ff3644" d="M120.2 152.7H85.6c-1.6 0-2.9 1.3-2.9 2.9v21.5c0 1.6 1.3 2.9 2.9 2.9s2.9-1.3 2.9-2.9v-18.6h28.8v18.6c0 1.6 1.3 2.9 2.9 2.9s2.9-1.3 2.9-2.9v-21.5c0-1.6-1.3-2.9-2.9-2.9z" data-color="1"></path>
        <path fill="#ff3644" d="M170.9 65.2L155.7 33c-.5-1-1.5-1.7-2.7-1.7-1.1 0-2.2.7-2.6 1.8l-13.7 32.1c-.2.4-.2.7-.2 1.1V170c0 5.5 4.4 9.9 9.9 9.9h14.7c5.5 0 9.9-4.4 9.9-9.9l.1-103.7c.1-.3 0-.8-.2-1.1zm-5.6 104.9c0 2.3-1.9 4.1-4.1 4.1h-14.7c-2.3 0-4.1-1.9-4.1-4.1V67l10.9-25.7L165.4 67l-.1 103.1z" data-color="1"></path>
        <path fill="#ff3644" d="M151 72.1v79.6c0 1.6 1.3 2.9 2.9 2.9 1.6 0 2.9-1.3 2.9-2.9V72.1c0-1.6-1.3-2.9-2.9-2.9-1.6 0-2.9 1.3-2.9 2.9z" data-color="1"></path>
        <path fill="#ff3644" d="M47 37c-.2 0-.4.2-.4.4v10.2c0 .2.2.4.4.4h10.2c.2 0 .4-.2.4-.4V37.4c0-.2-.2-.4-.4-.4H47z" data-color="1"></path>
    </g>
</svg>''',
    title: 'MEMBERSHIP',
    subtitle: '공방 자유이용',
    desc: '개인 작품활동, 지속적인 취미목공 등을 위해 공방을 자유롭게 이용할 수 있습니다.',
    route: '/membership',
  );

  const FeatureCard({required this.svgString, required this.title, required this.subtitle, required this.desc, required this.route});

  final String svgString;
  final String title;
  final String subtitle;
  final String desc;
  final String route;
}

class FeatureCardsSection extends StatelessWidget {
  const FeatureCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: SizedBox(
            height: 450,
            child: Row(
              children: FeatureCard.values.map((card) {
                return SizedBox(width: 245, child: _FeatureCardWidget(card: card));
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureCardWidget extends StatelessWidget {
  final FeatureCard card;

  const _FeatureCardWidget({required this.card});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.string(card.svgString, height: 90, colorFilter: const ColorFilter.mode(AppTheme.black, BlendMode.srcIn)),
          const SizedBox(height: 36),
          Text(card.title, style: AppTheme.sectionTitle()),
          const SizedBox(height: 24),
          Text(card.subtitle, style: AppTheme.bodyKorean()),
          const SizedBox(height: 24),
          Text(card.desc, style: AppTheme.bodyKoreanSmall(), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          SizedBox(
            width: 158,
            height: 35,
            child: TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.transparent, padding: EdgeInsets.zero),
              onPressed: () => context.go(card.route),
              child: Text('Read More >', style: AppTheme.navItem().copyWith(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
