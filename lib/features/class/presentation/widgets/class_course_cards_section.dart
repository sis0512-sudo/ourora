import 'package:flutter/material.dart';
import 'package:ourora/features/class/presentation/widgets/class_course_card.dart';

class ClassCourseCardsSection extends StatelessWidget {
  const ClassCourseCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ClassCourseCard(
          title: 'REGULAR COURSE',
          subTitle: '정규과정',
          description: '기초부터 중급, 고급까지 전문적인 목공 / 가구제작 기술과 디자인 표현 과정을 배울 수 있는 정규 수업입니다.',
          imagePath: 'assets/images/regular_course_background.webp',
        ),
        SizedBox(height: 8),
        ClassCourseCard(
          title: 'OURORA 8\nEXPERT CLASS',
          subTitle: '​오로라에잇 전문가반 클래스',
          description: '1년 풀타임 과정으로 목공을 넘어 가구 디자이너 또는 공예 작가로서의 성장을 목표로 합니다.',
          imagePath: 'assets/images/expert_course_background.webp',
          showLogo: true,
        ),
      ],
    );
  }
}
