// 작품 상세 페이지에서 여러 이미지를 세로로 나열하는 위젯.
// 첫 번째 이미지를 제외한 나머지 이미지들(imageUrls.skip(1))을 순서대로 표시합니다.
import 'package:flutter/material.dart';
import 'package:ourora/features/works/presentation/widgets/work_post/work_post_image.dart';

class WorkPostImageColumn extends StatelessWidget {
  final List<String> imageUrls; // 표시할 이미지 URL 목록

  const WorkPostImageColumn({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) return const SizedBox.shrink(); // 이미지가 없으면 빈 공간

    return ListView.separated(
      shrinkWrap: true, // Column 안에서 ListView를 사용할 때 필요한 설정
      physics: const NeverScrollableScrollPhysics(), // 부모 ScrollView가 스크롤 담당
      itemCount: imageUrls.length,
      // separatorBuilder: 각 이미지 사이에 16px 간격 추가
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) => WorkPostImage(imageUrl: imageUrls[index]),
    );
  }
}
