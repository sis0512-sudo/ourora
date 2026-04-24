// 홈 화면의 인스타그램 사진 그리드 섹션.
// InstagramController를 통해 게시물을 페이지 단위로 불러오고,
// 'Load More' 버튼으로 추가 게시물을 가져올 수 있습니다.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/application/instagram_controller.dart';
import 'package:ourora/features/common/infrastructure/entities/instagram_post.dart';
import 'package:ourora/features/common/utils/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

// ConsumerWidget: Riverpod의 ref.watch()를 사용하는 StatelessWidget
class InstagramGridSection extends ConsumerWidget {
  const InstagramGridSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = Responsive.isMobileDevice;
    final pageSize = isMobile ? 8 : 9; // 모바일은 4열×2행=8개, 데스크톱은 3열×3행=9개
    // instagramControllerProvider(pageSize): 한 페이지당 불러올 게시물 수를 파라미터로 전달
    final feed = ref.watch(instagramControllerProvider(pageSize));
    final columns = Responsive.gridColumns(context); // 모바일: 1열, 데스크톱: 3열

    return Container(
      color: AppTheme.white,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 0 : 80),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 32 : 100),
            child: _buildGrid(context, ref, feed, columns),
          ),
          // 로딩 중일 때 스피너 표시
          if (feed.isLoading) ...[
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          // 더 불러올 게시물이 있으면 'Load More' 버튼 표시
          ] else if (feed.hasMore) ...[
            const SizedBox(height: 40),
            _loadMoreButton(ref, isMobile, pageSize),
          ],
        ],
      ),
    );
  }

  // 그리드 레이아웃을 구성합니다.
  // 게시물이 없고 로딩 중도 아닐 때: 에러 메시지 또는 빈 화면 표시
  Widget _buildGrid(BuildContext context, WidgetRef ref, InstagramFeedState feed, int columns) {
    final isMobile = Responsive.isMobileDevice;

    if (feed.posts.isEmpty && !feed.isLoading) {
      if (feed.error != null) {
        return Center(child: Text('불러올 수 없습니다.', style: AppTheme.bodyKorean(isMobile)));
      }
      return const SizedBox.shrink(); // 에러도 없고 데이터도 없으면 빈 공간
    }

    return GridView.builder(
      shrinkWrap: true, // Column 안에서 GridView를 사용할 때 필요한 설정
      physics: const NeverScrollableScrollPhysics(), // 그리드 자체의 스크롤 비활성화 (부모 ScrollView가 담당)
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: feed.posts.length,
      itemBuilder: (context, index) => _GridItem(post: feed.posts[index]),
    );
  }

  // 'Load More' 버튼: 클릭 시 다음 페이지 게시물을 추가로 불러옵니다.
  Widget _loadMoreButton(WidgetRef ref, bool isMobile, int pageSize) {
    return SizedBox(
      width: isMobile ? 200 : 150,
      height: isMobile ? 56 : 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppTheme.accentOrange),
          padding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          overlayColor: AppTheme.transparent,
        ),
        onPressed: () => ref.read(instagramControllerProvider(pageSize).notifier).loadMore(),
        child: Text(
          'Load More',
          style: TextStyle(fontFamily: 'ArialBlack', fontSize: isMobile ? 18 : 13, color: AppTheme.accentOrange),
        ),
      ),
    );
  }
}

// 그리드의 각 셀(인스타그램 게시물 하나)을 표시하는 위젯.
// 호버 시 어두운 오버레이와 캡션 텍스트가 나타납니다.
class _GridItem extends StatefulWidget {
  final InstagramPost post;

  const _GridItem({required this.post});

  @override
  State<_GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<_GridItem> {
  bool _hovered = false; // 마우스 호버 상태

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        // 클릭 시 인스타그램 원본 게시물 페이지를 새 탭에서 엽니다.
        onTap: () => launchUrl(Uri.parse(widget.post.permalink), mode: LaunchMode.externalApplication),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 게시물 이미지 (동영상이면 썸네일 사용)
            Image.network(
              widget.post.displayUrl,
              fit: BoxFit.cover,
              cacheWidth: 400,  // 메모리 절약을 위해 최대 400px로 디코딩
              cacheHeight: 400,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppTheme.lightGray,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.coral,
                      value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                    ),
                  ),
                );
              },
            ),
            // 동영상 게시물에는 재생 아이콘 오버레이 표시
            if (widget.post.mediaType == 'VIDEO') const Center(child: Icon(Icons.play_circle_outline, color: AppTheme.white, size: 40)),
            // 호버 시 어두운 오버레이 + 캡션 텍스트
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _hovered ? 1.0 : 0.0,
              child: Container(
                color: AppTheme.black.withValues(alpha: 0.65),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.post.mediaType == 'VIDEO') const Icon(Icons.play_circle_outline, color: AppTheme.white, size: 32),
                    if (widget.post.caption != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.post.caption!,
                        style: AppTheme.bodyKorean(isMobile).copyWith(color: AppTheme.white, fontSize: 16),
                        textAlign: TextAlign.center,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
