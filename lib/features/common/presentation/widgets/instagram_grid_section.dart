import 'package:cached_network_image/cached_network_image.dart';
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
    final feed = ref.watch(instagramControllerProvider);
    final columns = Responsive.gridColumns(context);

    return Container(
      color: AppTheme.white,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: _buildGrid(context, ref, feed, columns),
          ),
          if (feed.isLoading) ...[
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ] else if (feed.hasMore) ...[
            const SizedBox(height: 40),
            _loadMoreButton(ref),
          ],
        ],
      ),
    );
  }

  Widget _buildGrid(
    BuildContext context,
    WidgetRef ref,
    InstagramFeedState feed,
    int columns,
  ) {
    if (feed.posts.isEmpty && !feed.isLoading) {
      if (feed.error != null) {
        return Center(child: Text('불러올 수 없습니다.', style: AppTheme.bodyKorean()));
      }
      return const SizedBox.shrink();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: feed.posts.length,
      itemBuilder: (context, index) => _GridItem(post: feed.posts[index]),
    );
  }

  Widget _loadMoreButton(WidgetRef ref) {
    return SizedBox(
      width: 150,
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppTheme.accentOrange),
          padding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        onPressed: () => ref.read(instagramControllerProvider.notifier).loadMore(),
        child: const Text(
          'Load More',
          style: TextStyle(fontFamily: 'ArialBlack', fontSize: 13, color: AppTheme.black),
        ),
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  final InstagramPost post;

  const _GridItem({required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(imageUrl: post.displayUrl, fit: BoxFit.cover),
          if (post.mediaType == 'VIDEO')
            const Center(
              child: Icon(Icons.play_circle_outline, color: Colors.white70, size: 40),
            ),
        ],
      ),
    );
  }

  void _onTap(BuildContext context) {
    launchUrl(Uri.parse(post.permalink), mode: LaunchMode.externalApplication);
  }
}
