import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/class/presentation/widgets/class_header.dart';
import 'package:ourora/features/common/presentation/widgets/bullet_list.dart';
import 'package:ourora/features/common/presentation/widgets/image_viewer_popup.dart';
import 'package:ourora/features/common/presentation/widgets/nav_bar.dart';
import 'package:ourora/features/common/presentation/widgets/site_footer.dart';
import 'package:ourora/features/common/presentation/widgets/title_widget.dart';
import 'package:ourora/features/common/utils/utils.dart';

class Ourora8Screen extends StatefulWidget {
  static const String route = '/ourora8';

  const Ourora8Screen({super.key});

  @override
  State<Ourora8Screen> createState() => _Ourora8ScreenState();
}

class _Ourora8ScreenState extends State<Ourora8Screen> {
  bool _hovered = false;

  final descriptionStyle = GoogleFonts.notoSansKr(fontSize: 18, color: AppTheme.black);
  final EdgeInsetsGeometry titlePadding = const EdgeInsets.only(top: 60, bottom: 40);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(delegate: NavBarDelegate(), pinned: true),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 980),
                child: Column(
                  children: [
                    ClassHeader(
                      title: 'OURORA8\n오로라에잇 전문가반 클래스',
                      description: '최고 수준의 목공 기술을 기반으로 다양한 디자인 실험 및 자유로운 작품 창작이 가능한\n가구 디자이너 또는 공예 작가로서의 성장을 추구합니다.\n초보자를 대상으로 합니다.',
                      image: Image.asset('assets/images/ourora8_logo.webp', height: 134, fit: BoxFit.contain),
                    ),
                    Padding(padding: const EdgeInsets.only(top: 16), child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                      child: Column(
                        children: [
                          Text(
                            '오로라공방의 전문가반 클래스인 \'오로라에잇(ourora8)\'은 가구 제작을 위한 전문가 수준의 목공 기술 습득과 지속적인 디자인 연구를 위한 과정으로, 나아가 다양한 디자인 시도와 실험, 작품 창작 등을 중점적으로 진행하고 참여하는 1년 풀 타임(full-time) 과정입니다.',
                            style: GoogleFonts.notoSansKr(fontSize: 18, color: AppTheme.textGray),
                          ),
                          Padding(
                            padding: titlePadding,
                            child: const TitleWidget(title: '주요 교육내용', isSubTitle: false, alignment: CrossAxisAlignment.center),
                          ),
                          BulletList(
                            hideDivider: true,
                            title: '필수과목',
                            items: const [
                              TextSpan(text: '가구 제작 과정 이해'),
                              TextSpan(text: '수공구 사용방법, 세팅, 관리 (대패, 톱, 끌 등)'),
                              TextSpan(text: '동서양 짜맞춤(joinery) 기법 이해와 숙련 및 응용'),
                              TextSpan(text: '컴퓨터를 이용한 2D, 3D 설계와 렌더링 (AutoCAD, Fusion360, KeyShot)'),
                              TextSpan(text: '작품 콘셉팅 / 디자인 전개 방법의 이해와 훈련'),
                              TextSpan(text: '가구 재료의 이해'),
                              TextSpan(text: '목공 응용 기술'),
                              TextSpan(text: '​목공예 / 우드카빙'),
                              TextSpan(text: '목공 기계 사용 및 응용 ​(수압/자동 대패, 테이블쏘, 라우터 등)'),
                              TextSpan(text: '가구 ​마감(샌딩, 페인트, 오일 등) 기법'),
                              TextSpan(text: '​​문화/예술/디자인 이론 및 역사'),
                              TextSpan(text: '개별 작품 연구 / 제작, 스케일 목업'),
                              TextSpan(text: '​작품 전시'),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              onEnter: (_) => setState(() => _hovered = true),
                              onExit: (_) => setState(() => _hovered = false),
                              child: OutlinedButton(
                                onPressed: () => ImageViewerPopup.show(context, images: ['assets/images/ourora8_course.png']),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.transparent),
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
                                  backgroundColor: _hovered ? Color(0xFFFF6161) : AppTheme.black,
                                  foregroundColor: AppTheme.white,
                                  surfaceTintColor: Colors.transparent,
                                  overlayColor: Colors.transparent,
                                ),
                                child: SizedBox(
                                  width: 200,
                                  child: Center(
                                    child: Text(
                                      '커리큘럼 자세히 보기',
                                      style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.white, letterSpacing: 1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          BulletList(
                            hideDivider: true,
                            title: '비정기 선택과목',
                            items: const [
                              TextSpan(text: '국내외 공모전 출품'),
                              TextSpan(text: '본 전시 외 공방 과제전 또는 팝업전시 참여'),
                              TextSpan(text: '전시회 관람 / 목재소 / 타 공방 견학'),
                              TextSpan(text: '기계 및 공구 세팅 / 유지보수 방법 교육'),
                              TextSpan(text: '국가자격증 준비 - 가구제작, 목공예'),
                            ],
                          ),
                          Padding(
                            padding: titlePadding,
                            child: const TitleWidget(title: '등록안내', isSubTitle: false, alignment: CrossAxisAlignment.center),
                          ),
                          BulletList(
                            hideDivider: true,
                            items: const [
                              TextSpan(
                                children: [
                                  TextSpan(text: '모집기간 : '),
                                  TextSpan(
                                    text: '*상시모집',
                                    style: TextStyle(color: AppTheme.red),
                                  ),
                                  TextSpan(text: ' (개인별 진도 방식으로 바로 시작 가능)'),
                                ],
                              ),
                              TextSpan(text: '수업기간 : 시작일로부터, 1년(12개월) 과정'),
                              TextSpan(text: '수업시간 : 주 2회 (회당 3~6시간 - 개인 일정에 따라 수업 요일 및 시간 협의 가능)'),
                              TextSpan(text: '자유실습 : 수업 외 시간 및 요일 제한없이 자유작업, 개인연습, 과제 수행 가능 (11:00~23:00)'),
                              TextSpan(text: '모집정원 : 년간 최대 8명으로 한 기수 구성'),
                              TextSpan(text: '등록 방법 : 자기소개, 지원목적 등을 간단히 작성 후, 이메일(contact@ourora.com) 접수 또는 방문상담 후 등록​'),
                              TextSpan(
                                children: [
                                  TextSpan(text: '수업료 : 800만원 (일시납부 또는 3개월 내 2회 분납 가능)'),
                                  TextSpan(text: '\n- 교재, 재료비 별도 (기본 수업재료 제공)', style: TextStyle(fontSize: 16, height: 2)),
                                  TextSpan(text: '\n- 개인 수공구 및 소모품 별도 (공방을 통해 구입 또는 각자 구매 가능)', style: TextStyle(fontSize: 16, height: 2)),
                                  TextSpan(text: '\n- 수업 시작일전까지 100% 환불되며, 그 이후부터는 환불되지 않습니다.', style: TextStyle(fontSize: 16, height: 2)),
                                  TextSpan(text: '\n   (현재 공방의 사업자 구분이 간이사업자로 되어 있어서 별도 VAT 없음)', style: TextStyle(fontSize: 16, height: 2)),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: titlePadding,
                            child: const TitleWidget(title: '수료 후 과정', isSubTitle: false, alignment: CrossAxisAlignment.center),
                          ),
                          Text(
                            Utils.formatText(
                              '수료 후, 바로 공방 창업은 위험할 수 있으며, 또는 바로 디자이너 및 작가로서의 활동이 현실적으로 어려울 수 있기에, 오로라에잇은 멤버분들께서 충분한 준비와 경험을 쌓을 수 있도록, 수료 후에도 자신만의 스타일과 작품세계를 만들 수 있는 \'오로라에잇츠(ourora8s)\'*를 운영하여 꾸준한 작품 활동을 지원하며, 창업 준비를 희망하는 분들의 경우 다양한 사업적 경험을 쌓을 수 있도록 공방내에서 상업활동이 가능한 오로라펠로우(ourora fellow)**로 활동할 수 있는 기회를 제공합니다. 지속적으로 오로라공방과의 협업모델을 개발 / 지원할 예정입니다.',
                            ),
                            style: GoogleFonts.notoSansKr(fontSize: 18, color: AppTheme.textGray),
                          ),
                          BulletList(
                            items: [
                              TextSpan(text: '과정이수 후, 수료 전까지 멤버십(연구반) 등록 가능 (월 20만원, 공방 자유이용)'),
                              TextSpan(
                                children: [
                                  TextSpan(text: '​수료 후, 오로라에잇츠(ourora8s)* 소속 디자이너/작가로 활동 가능'),
                                  TextSpan(text: '\n- 수료자에 한하여 선발(기간제한 없음)', style: TextStyle(fontSize: 16, height: 2)),
                                  TextSpan(text: '\n- ​연 2회 이상 전시 참여 기회 제공', style: TextStyle(fontSize: 16, height: 2)),
                                ],
                              ),
                              TextSpan(
                                children: [
                                  TextSpan(text: '수료 후, 창업 준비를 희망할 경우 오로라펠로우** 활동 가능'),
                                  TextSpan(text: '\n- 수료자에 한하여 선발(기간제한 없음)', style: TextStyle(fontSize: 16, height: 2)),
                                  TextSpan(text: '\n- 선발 후, 협력 파트너십 체결 이후부터 상업활동 가능', style: TextStyle(fontSize: 16, height: 2)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: const EdgeInsets.only(top: 16), child: Divider()),
                    Text(
                      Utils.formatText(
                        '*오로라에잇츠(ourora8s) : 오로라공방의 지원을 받아 목공예 또는 작품가구 위주의 제작 및 전시, 출품 등의 작품활동을 하는 작가 그룹입니다.\n**오로라펠로우(ourora fellow) : 자신 만의 상품개발(샘플링)을 물론, 교육시 조교 또는 강의를 할 수 있고, 상품 판매, 주문제작 등 공방에서 상업적 활동을 하실 수 있는 파트너입니다.',
                      ),
                      style: GoogleFonts.notoSansKr(fontSize: 16, color: AppTheme.textGray),
                    ),
                    const SizedBox(height: 60),
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
