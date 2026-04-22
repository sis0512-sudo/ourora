import 'package:flutter/material.dart';
import 'package:ourora/features/common/presentation/widgets/image_viewer_popup.dart';

class WorkPostImage extends StatelessWidget {
  final String imageUrl;

  const WorkPostImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => ImageViewerPopup.show(context, imageUrls: [imageUrl]),
        child: Image.network(imageUrl, fit: BoxFit.contain),
      ),
    );
  }
}
