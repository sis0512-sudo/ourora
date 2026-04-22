import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/application/instagram_controller.dart';
import 'package:ourora/features/common/infrastructure/entities/instagram_post.dart';
import 'package:ourora/features/common/utils/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

class InstagramGridSection extends ConsumerWidget {
  const InstagramGridSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = Responsive.isMobileDevice;
    final pageSize = isMobile ? 8 : 9;
    final feed = ref.watch(instagramControllerProvider(pageSize));
    final columns = Responsive.gridColumns(context);

    return Container(
      color: AppTheme.white,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 0 : 80),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 32 : 100),
            child: _buildGrid(context, ref, feed, columns),
          ),
          if (feed.isLoading) ...[
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ] else if (feed.hasMore) ...[
            const SizedBox(height: 40),
            _loadMoreButton(ref, isMobile, pageSize),
          ],
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context, WidgetRef ref, InstagramFeedState feed, int columns) {
    final isMobile = Responsive.isMobileDevice;

    if (feed.posts.isEmpty && !feed.isLoading) {
      if (feed.error != null) {
        return Center(child: Text('불러올 수 없습니다.', style: AppTheme.bodyKorean(isMobile)));
      }
      return const SizedBox.shrink();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: feed.posts.length,
      itemBuilder: (context, index) => _GridItem(post: feed.posts[index]),
    );
  }

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

class _GridItem extends StatefulWidget {
  final InstagramPost post;

  const _GridItem({required this.post});

  @override
  State<_GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<_GridItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.post.permalink), mode: LaunchMode.externalApplication),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.post.displayUrl,
              fit: BoxFit.cover,
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
            if (widget.post.mediaType == 'VIDEO') const Center(child: Icon(Icons.play_circle_outline, color: AppTheme.white, size: 40)),
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
