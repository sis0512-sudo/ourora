import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class YoutubeFeedSection extends StatelessWidget {
  const YoutubeFeedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.lightGray,
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              '⠿  Youtube Feed',
              style: AppTheme.sectionTitle(),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 320,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 32),
              itemCount: AppConstants.youtubeVideoIds.length,
              itemBuilder: (context, index) {
                return _YoutubeCard(
                  videoId: AppConstants.youtubeVideoIds[index],
                  title: AppConstants.youtubeTitles[index],
                  duration: AppConstants.youtubeDurations[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _YoutubeCard extends StatelessWidget {
  final String videoId;
  final String title;
  final String duration;

  const _YoutubeCard({
    required this.videoId,
    required this.title,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(
        Uri.parse(AppConstants.videoUrl(videoId)),
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
                  imageUrl: AppConstants.thumbnailUrl(videoId),
                  width: 320,
                  height: 180,
                  fit: BoxFit.cover,
                ),
                // 재생 버튼 오버레이
                const Positioned.fill(
                  child: Center(
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white70,
                      child: Icon(Icons.play_arrow, color: AppTheme.black, size: 28),
                    ),
                  ),
                ),
                // 영상 길이
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    color: Colors.black87,
                    child: Text(
                      duration,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                title,
                style: AppTheme.bodyKorean(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
