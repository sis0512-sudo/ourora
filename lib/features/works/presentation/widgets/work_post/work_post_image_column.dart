import 'package:flutter/material.dart';
import 'package:ourora/features/works/presentation/widgets/work_post/work_post_image.dart';

class WorkPostImageColumn extends StatelessWidget {
  final List<String> imageUrls;

  const WorkPostImageColumn({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) return const SizedBox.shrink();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: imageUrls.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) => WorkPostImage(imageUrl: imageUrls[index]),
    );
  }
}
