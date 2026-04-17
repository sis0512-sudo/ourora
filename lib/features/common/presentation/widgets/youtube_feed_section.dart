import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/domain/youtube_video.dart';
import 'package:ourora/features/common/presentation/providers/youtube_provider.dart';
import 'package:ourora/features/common/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class YoutubeFeedSection extends ConsumerWidget {
  const YoutubeFeedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videosAsync = ref.watch(youtubeVideosProvider);

    return Container(
      color: AppTheme.lightGray,
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text('⠿  Youtube Feed', style: AppTheme.sectionTitle()),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 320,
            child: videosAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const Center(child: Text('영상을 불러올 수 없습니다.')),
              data: (videos) => ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                itemCount: videos.length,
                itemBuilder: (context, index) =>
                    _YoutubeCard(video: videos[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _YoutubeCard extends StatelessWidget {
  final YoutubeVideo video;

  const _YoutubeCard({required this.video});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(
        Uri.parse(AppConstants.videoUrl(video.videoId)),
        mode: LaunchMode.externalApplication,
      ),
      child: Container(
        width: 320,
        margin: const EdgeInsets.only(right: 16),
        color: AppTheme.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: video.thumbnailUrl,
                  width: 320,
                  height: 180,
                  fit: BoxFit.cover,
                ),
                const Positioned.fill(
                  child: Center(
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white70,
                      child: Icon(Icons.play_arrow, color: AppTheme.black, size: 28),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    color: Colors.black87,
                    child: Text(
                      video.duration,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: Text(
                video.title,
                style: AppTheme.bodyKorean(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (video.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Text(
                  video.description,
                  style: AppTheme.bodyKorean().copyWith(
                    fontSize: 12,
                    color: AppTheme.textGray.withValues(alpha: 0.7),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
