// 작품 상세 페이지에서 이미지 하나를 표시하는 위젯.
// 클릭 시 ImageViewerPopup으로 전체 화면 확대 팝업을 엽니다.
import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/image_viewer_popup.dart';

class WorkPostImage extends StatelessWidget {
  final String imageUrl;

  const WorkPostImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        // 클릭 시 해당 이미지를 팝업으로 확대 표시
        onTap: () => ImageViewerPopup.show(context, imageUrls: [imageUrl]),
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppTheme.coral,
                value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
              ),
            );
          },
        ),
      ),
    );
  }
}
