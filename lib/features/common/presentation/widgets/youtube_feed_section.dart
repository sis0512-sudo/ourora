import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/application/youtube_controller.dart';
import 'package:ourora/features/common/presentation/widgets/youtube_arrow_button.dart';
import 'package:ourora/features/common/presentation/widgets/youtube_card.dart';
import 'package:ourora/features/common/utils/responsive.dart';

class YoutubeFeedSection extends ConsumerStatefulWidget {
  const YoutubeFeedSection({super.key});

  @override
  ConsumerState<YoutubeFeedSection> createState() => _YoutubeFeedSectionState();
}

class _YoutubeFeedSectionState extends ConsumerState<YoutubeFeedSection> {
  final _scrollController = ScrollController();
  bool _atStart = true;
  bool _atEnd = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateArrows);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateArrows);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateArrows() {
    final pos = _scrollController.position;
    setState(() {
      _atStart = pos.pixels <= 0;
      _atEnd = pos.pixels >= pos.maxScrollExtent;
    });
  }

  void _scrollBy(double delta) {
    _scrollController.animateTo(
      (_scrollController.offset + delta).clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final videosAsync = ref.watch(youtubeControllerProvider);
    final isMobile = Responsive.isMobileDevice;

    return Container(
      color: AppTheme.white,
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kYoutubeArrowWidth + 32),
            child: Text('⠿  Youtube Feed', style: AppTheme.mainSectionTitle()),
          ),
          const SizedBox(height: 24),
          isMobile
              ? Column(
                  children: [
                    videosAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (_, _) => const Center(child: Text('영상을 불러올 수 없습니다.')),
                      data: (videos) => Column(
                        children: videos
                            .map(
                              (video) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: YoutubeCard(video: video),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                )
              : SizedBox(
                  height: kYoutubeThumbnailHeight + 140,
                  child: videosAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, _) => const Center(child: Text('영상을 불러올 수 없습니다.')),
                    data: (videos) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 32),
                        YoutubeArrowButton(direction: YoutubeArrowDirection.prev, disabled: _atStart, onTap: () => _scrollBy(-kYoutubeCardWidth)),
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: videos.length,
                            itemBuilder: (context, index) => YoutubeCard(video: videos[index]),
                          ),
                        ),
                        YoutubeArrowButton(direction: YoutubeArrowDirection.next, disabled: _atEnd, onTap: () => _scrollBy(kYoutubeCardWidth)),
                        const SizedBox(width: 32),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
