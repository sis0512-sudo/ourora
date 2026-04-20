import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/responsive.dart';

class InstagramGridSection extends StatefulWidget {
  const InstagramGridSection({super.key});

  @override
  State<InstagramGridSection> createState() => _InstagramGridSectionState();
}

class _InstagramGridSectionState extends State<InstagramGridSection> {
  // 실제 이미지 URL 또는 asset 경로로 교체
  static const List<String> _allImages = [
    'https://via.placeholder.com/400',
    'https://via.placeholder.com/400',
    'https://via.placeholder.com/400',
    'https://via.placeholder.com/400',
    'https://via.placeholder.com/400',
    'https://via.placeholder.com/400',
    'https://via.placeholder.com/400',
    'https://via.placeholder.com/400',
    'https://via.placeholder.com/400',
  ];

  int _displayCount = 6;

  @override
  Widget build(BuildContext context) {
    final columns = Responsive.gridColumns(context);
    final displayed = _allImages.take(_displayCount).toList();

    return Container(
      color: AppTheme.white,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: displayed.length,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: displayed[index],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          if (_displayCount < _allImages.length) ...[
            const SizedBox(height: 40),
            SizedBox(
              width: 150,
              height: 48,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.accentOrange),
                  padding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _displayCount =
                        (_displayCount + 6).clamp(0, _allImages.length);
                  });
                },
                child: Text('Load More', style: const TextStyle(fontFamily: 'ArialBlack', fontSize: 13, color: AppTheme.black)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
