import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/about/presentation/screens/about_screen.dart';
import 'package:ourora/features/about/presentation/widgets/fidp_card.dart';
import 'package:ourora/features/common/presentation/widgets/nav_bar.dart';
import 'package:ourora/features/common/presentation/widgets/site_footer.dart';
import 'package:ourora/features/common/utils/utils.dart';

class FIDPScreen extends StatefulWidget {
  static const String route = '/fidp';

  const FIDPScreen({super.key});

  @override
  State<FIDPScreen> createState() => _FIDPScreenState();
}

class _FIDPScreenState extends State<FIDPScreen> with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(duration: const Duration(milliseconds: 1400), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(begin: const Offset(-0.1, 0), end: Offset.zero).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(delegate: NavBarDelegate(), pinned: true),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 389,
              child: Stack(
                children: [
                  CachedNetworkImage(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/ourora-78e54.firebasestorage.app/o/images%2Ffidp_background.webp?alt=media&token=cbe81dfb-ddc0-437c-821b-73bbfd0518bf', fit: BoxFit.cover, width: double.infinity, height: 389, alignment: Alignment.bottomCenter),
                  Positioned.fill(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Text(
                              'F + I + D + P',
                              style: const TextStyle(
                                fontFamily: 'ArialBlack',
                                fontSize: 110,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.black,
                                letterSpacing: 3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 980),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) => setState(() => _hovered = true),
                        onExit: (_) => setState(() => _hovered = false),
                        child: GestureDetector(
                          onTap: () => context.go(AboutScreen.route),
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 150),
                            style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w400, color: _hovered ? AppTheme.red : AppTheme.textGray),
                            child: Padding(padding: const EdgeInsets.all(8.0), child: Text('< ABOUT 페이지로 돌아가기')),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      Utils.formatText('오로라공방은 가구(Furniture)와 IT(Information Technology), 그리고 디자인(Design)과 사람(People)이라는 4가지 주제들과 함께 합니다.'),
                      style: GoogleFonts.nanumMyeongjo(fontSize: 18, color: AppTheme.black),
                    ),
                    const SizedBox(height: 40),
                    FidpCard(
                      initial: 'F',
                      title: '가구를 제작하는 목공방',
                      description:
                          '오로라공방은 목가구 제작에 대한 기술을 폭넓게 활용하여 가구를 제작합니다. 가구를 쉽고 빠르게 제작할 수 있는 DIY 제작방법에서 부터 집성판, 합판 등의 판재 및 소프트우드, 하드우드 등의 다양한 목재 활용 및 가공 방법, 수공구를 활용한 보다 정밀하고 높은 수준의 제작 기술, 기계를 활용한 효율적 제작 방법, 그 외 다양한 목공 응용기술 등에 대해 항상 연구하고 개발합니다. 뿐만 아니라, 동서양의 전통 가구 제작 기법들을 습득하고 나아가 현대 가구의 새로운 기법들을 탐구하여, 오로라공방이 생산하는 제품의 디자인 구현에 최적화된 방법을 끊임없이 연구합니다.',
                      alignToLeft: true,
                      bullets: [
                        TextSpan(text: '쉽고 빠르게 제작 가능한 DIY 제작 방법'),
                        TextSpan(text: '수공구를 활용한 정밀 가공 기술'),
                        TextSpan(text: '각종 짜맞춤 기법을 활용한 높은 수준의 제작 기술'),
                        TextSpan(text: '원목 집성판, 합판 등의 판재 및 소프트우드, 하드우드 가공 기술'),
                        TextSpan(text: '기계를 활용한 효율적 제작 방법'),
                        TextSpan(text: '​다양한 목공 응용기술 연구 및 개발'),
                      ],
                    ),
                    FidpCard(
                      initial: 'I',
                      title: '가구와 IT기술과의 융합',
                      description:
                          '오로라공방은 4차 산업혁명의 핵심 기술 중 사물인터넷(IoT : Internet of Things)과 3D 프린팅에서 가구 디자인에 대한 새로운 디자인 가능성을 고민하고 있습니다. 특히 마이크 쿠니아브스키의 저서 Smart Things: Ubiquitous Computing User Experience Design(한국어 책 \'생.각.하.는. 냉장고 뉴.스.읽.는. 장난감\')에서 처럼 사물인터넷(IoT : Internet of Things)은 더 이상 먼 곳의 이야기가 아닌 지금 우리 집 안에서 시작되고 있습니다. 이미 출시된 수많은 가전제품들을 보면 알 수 있듯이 말입니다. 오로라공방은 집안에서 가전제품보다 더 가까이 우리 삶과 맞닿아 있는 가구들이 IT기술과의 융합을 통해, 사람들이 보다 편리한 라이프 스타일을 누릴 수 있도록 가구에 접목할 수 있는 사물인터넷 기술과 3D 프린팅에 대한 다양한 시도를 통해 디자인의 한계를 넘어서고 나아가 가구의 새로운 방향을 탐구합니다. 또한 회원분들께서 보다 다양한 아이디어들을 표현하고 구체화할 수 있도록 관련 교육을 제공합니다.',
                      alignToLeft: false,
                    ),
                    FidpCard(
                      initial: 'D',
                      title: '디자인을 통해 다양한 문제들을 바라봅니다.',
                      description:
                          '오로라공방은 디자인에 대한 깊은 이해와 철학, 미술, 과학적 연구를 바탕으로 진정성있는 디자인을 추구합니다. 디자이너 개인의 관점과 스타일을 바탕으로 최종 소비자(User)의 라이프 스타일을 다각도로 바라보고 여러 개선점들을 다양한 디자인 방법론을 통해 분석하여 최적의 디자인 솔루션을 도출합니다. 이는 디자인의 보편적 가치 제공과 더불어, 제작된 제품이 보다 많은 분들에게 편리함과 나아가 윤택한 삶을 제공할 수 있는 기반을 만들어 줍니다.',
                      alignToLeft: true,
                      bullets: [
                        TextSpan(text: 'Design Methodology - ​디자인을 위한 효과적인 방법론 연구'),
                        TextSpan(text: 'Interaction Design - 제품과 사용자간의 상호작용 원리 연구'),
                        TextSpan(text: 'Design Research through Phenomenology - 현상학적 디자인 연구'),
                        TextSpan(text: 'Usability - 사용성 연구'),
                        TextSpan(text: 'Service Design - 서비스 디자인 연구'),
                      ],
                    ),
                    FidpCard(
                      initial: 'P',
                      title: '공장이 아닌 공방을 운영하여 누구나 참여할 수 있는 경험을 제공합니다.',
                      description:
                          '오로라공방은 나무로 가구를 만드는 가구공방 또는 목공방입니다.\n그러나 공방의 주된 목적은 가구 제작만을 추구하지 않습니다. 사람들이 보다 자유롭게 자신만의 작품을 만들고 그 과정에서 공방의 문화를 느낄 수 있는 그런 공간이 되길 원합니다. 단순히 주어진 시간에 목공기술을 배우러오거나 제작하는 공간을 넘어서, 사람들이 가구에 대해 서로의 아이디어들을 교류하여 더 재미있는 디자인을 상상하거나 혹은 제작을 하지 않더라도 퇴근 후 잠깐의 여유를 누릴 수 있는 그런 공간이 되고 싶습니다. 기술은 지속적으로 연마한다면 누구나 실력이 향상될 수 있습니다. 그러나 디자인에 대한 고민과 도전, 그리고 자신만의 작품에 대한 열정, 그 과정에서 누리는 즐거움은 열린 마음에서 시작된다고 믿기 때문입니다.',
                      alignToLeft: false,
                    ),
                    const SizedBox(height: 200),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SiteFooter()),
        ],
      ),
    );
  }
}
