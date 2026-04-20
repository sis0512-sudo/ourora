import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/class/presentation/widgets/class_header.dart';
import 'package:ourora/features/class/presentation/widgets/regular/regular_card.dart';
import 'package:ourora/features/common/presentation/widgets/nav_bar.dart';
import 'package:ourora/features/common/presentation/widgets/site_footer.dart';

class RegularCourseScreen extends StatefulWidget {
  static const String route = '/regular-course';
  const RegularCourseScreen({super.key});

  @override
  State<RegularCourseScreen> createState() => _RegularCourseScreenState();
}

class _RegularCourseScreenState extends State<RegularCourseScreen> {
  final descriptionStyle = GoogleFonts.notoSansKr(fontSize: 18, color: AppTheme.black);

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
                      title: 'REGULAR COURSE\n정규과정',
                      description: '기초부터 차근차근 중급이상의 기술과 디자인 스킬을\n습득할 수 있는 정규과정입니다.',
                      image: SvgPicture.asset('assets/svgs/regular_course.svg', height: 200, fit: BoxFit.contain),
                    ),
                    RegularCard(
                      descriptionStyle: descriptionStyle,
                      titleCaption: 'R-01',
                      title: '정규반-초급',
                      description: '목공을 처음 접하시는 분들을 위한 정규과정으로, 수공구를 중심으로 높은 수준의 목공 입문을 위한 첫걸음입니다.',
                      bullets: [
                        '주 2회 기준 3~6개월 과정(1회 3시간 수업) *개인별 진도에 따라 기간 다름',
                        '목재 이론 및 가구 제작 과정 이해',
                        '수공구(톱, 끌, 대패) 기초 교육 및 연마 / 세팅',
                        '짜맞춤 기초 교육 (Box joint, Dovetail joint 등)',
                        '가구 제작 실습 (재료비 별도):\n지정작품 - 본인의 스타일 및 용도에 따라 사이즈 등 일부 디자인 변경 가능',
                        '비트형 가공기계 기초 (트리머 등)',
                        '​가구 마감(샌딩 및 오일, 셀락 등 페인팅) 기법',
                        '주 1회 월 20만원 (총 4회) (주 2회 월 38만원)',
                      ],
                      curriculumImages: ['assets/images/course_1_1.png'],
                    ),
                    RegularCard(
                      descriptionStyle: descriptionStyle,
                      titleCaption: 'R-02',
                      title: '정규반-중급',
                      description: '보다 심도있는 기술 연마와 더불어 본격적인 가구 제작을 위한 심화 이론들을 익히고 설계 방법 및 안전한 기계 사용과 응용 기법을 습득합니다.',
                      bullets: [
                        '주 2회 기준 3~6개월 과정(1회 3시간 수업) *개인별 진도에 따라 기간 다름',
                        '​수공구 심화 교육\n: 대패 심화(남경대패, 배대패, 외원대패 등 특수/복합대패), 칼금, 줄, 스크래퍼, Coping/Keyhole saw 등 다양한 수공구 활용 및 요령',
                        '짜맞춤 심화 이론 및 기술 연마\n: Mortise & tenon, Tongue & groove, Spline, Edge joining, Bridle joint, Splined miter, 3-ways miter 등 동서양 짜맞춤 기술 및 원리, 사용목적 이해',
                        '​도면 이해 및 작도법',
                        '컴퓨터를 활용한 가구설계 (Sketch Up)',
                        '기계 사용 및 안전 교육\n: 수압대패, 자동대패, 테이블쏘 등 작동원리 / 안전수칙 / 응용 기술',
                        '제작 및 안전 계획 수립',
                        '사방탁자 제작 실습 (재료비 별도)\n: 지정작품 - 본인의 스타일 및 용도에 따라 사이즈 등 일부 디자인 변경 가능',
                        '주 1회 월 20만원 (총 4회) (주 2회 월 38만원)',
                      ],
                      curriculumImages: ['assets/images/course_2_1.png', 'assets/images/course_2_2.png'],
                    ),
                    RegularCard(
                      descriptionStyle: descriptionStyle,
                      titleCaption: 'R-03',
                      title: '정규반-고급',
                      description: '지금까지 연마한 기술과 경험을 바탕으로 자신이 직접 디자인하고 제작하는 가구제작의 전 과정을 실습하는 고급 과정입니다.',
                      bullets: [
                        '주 2회 기준 3~6개월 과정(1회 3시간 수업) *개인별 진도에 따라 기간 다름',
                        '컴퓨터를 활용한 가구설계 및 3D 렌더링 (Sketch Up, Keyshot)',
                        '가구 제작 연구 A (고급 가구)',
                        '기계 심화 교육 (가공을 위한 기계 응용 기술 및 필수 안전 수칙 숙련)',
                        '가구 제작 연구 B (자유작)',
                        '주 1회 월 20만원 (총 4회) (주 2회 월 38만원)',
                      ],
                      note: '*고급 과정은 디자인 발표 및 기획, 제작계획 수업에서 디스커션 과정이 있으므로, 지원자 수가 일정 인원 이상시 비정기적으로 개설됩니다. (별도 공지 예정)',
                      curriculumImages: ['assets/images/course_3_1.png'],
                    ),
                    RegularCard(
                      title: '수업시간표',
                      description:
                          '※ 개인별 진도로 진행하므로, 주 1~2회 원하시는 시간에 수업을 들으실 수 있습니다.\n※ 원활한 수업진행을 위해 각 시간별 최대 인원은 5명입니다. 수업 등록시 희망 시간에 배정된 인원 수를 사전에 문의 후 등록하여 주시기 바랍니다.',
                      descriptionStyle: descriptionStyle,
                      image: Image.asset('assets/images/regular_course_timetable.png', width: 600, fit: BoxFit.contain),
                    ),
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
