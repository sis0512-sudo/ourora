import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/bullet_list.dart';

class ClassEnvironmentSection extends StatelessWidget {
  const ClassEnvironmentSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80, bottom: 40),
      child: Column(
        children: [
          BulletList(
            title: '수업 환경',
            items: const [
              TextSpan(text: '작업대 : 작업실 2인용 3대, 기계실 2인용 1대, 1인용 2대, (필요시)확장테이블 1대'),
              TextSpan(text: '기계실 장비 리스트'),
            ],
          ),
          Image.network(
            'https://firebasestorage.googleapis.com/v0/b/ourora-78e54.firebasestorage.app/o/images%2Fmachine_list.webp?alt=media&token=b7a3113e-619b-4bf5-abd0-26365484f931',
            fit: BoxFit.cover,
            height: 780,
            cacheHeight: 780,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 780,
                color: AppTheme.lightGray,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.accentOrange, value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null)),
              );
            },
          ),
        ],
      ),
    );
  }
}
