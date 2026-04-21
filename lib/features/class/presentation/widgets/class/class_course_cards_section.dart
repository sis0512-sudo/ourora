import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ourora/features/class/presentation/screens/ourora8_screen.dart';
import 'package:ourora/features/class/presentation/screens/regular_course_screen.dart';
import 'package:ourora/features/class/presentation/widgets/class/class_course_card.dart';

class ClassCourseCardsSection extends StatelessWidget {
  const ClassCourseCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClassCourseCard(
          title: 'REGULAR COURSE',
          subTitle: '정규과정',
          description: '기초부터 중급, 고급까지 전문적인 목공 / 가구제작 기술과 디자인 표현 과정을 배울 수 있는 정규 수업입니다.',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/ourora-78e54.firebasestorage.app/o/images%2Fregular_course_background.webp?alt=media&token=3a64b694-3f6f-4836-bd55-1d32c4b92321',
          onTap: () => context.go(RegularCourseScreen.route),
        ),
        SizedBox(height: 8),
        ClassCourseCard(
          title: 'OURORA 8\nEXPERT CLASS',
          subTitle: '​오로라에잇 전문가반 클래스',
          description: '1년 풀타임 과정으로 목공을 넘어 가구 디자이너 또는 공예 작가로서의 성장을 목표로 합니다.',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/ourora-78e54.firebasestorage.app/o/images%2Fexpert_course_background.webp?alt=media&token=410063ee-8f09-4293-9e19-e83624b27fcf',
          showLogo: true,
          onTap: () => context.go(Ourora8Screen.route),
        ),
      ],
    );
  }
}
