// 홈 화면의 YouTube 영상 피드 섹션.
// 데스크톱: 가로 스크롤 리스트(좌/우 화살표 버튼 포함)
// 모바일: 세로 Column 배치
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/application/youtube_controller.dart';
import 'package:ourora/features/common/presentation/widgets/youtube_arrow_button.dart';
import 'package:ourora/features/common/presentation/widgets/youtube_card.dart';
import 'package:ourora/features/common/utils/responsive.dart';

// ConsumerStatefulWidget: Riverpod + State가 모두 필요한 위젯
class YoutubeFeedSection extends ConsumerStatefulWidget {
  const YoutubeFeedSection({super.key});

  @override
  ConsumerState<YoutubeFeedSection> createState() => _YoutubeFeedSectionState();
}

class _YoutubeFeedSectionState extends ConsumerState<YoutubeFeedSection> {
  final _scrollController = ScrollController(); // 가로 스크롤 컨트롤러
  bool _atStart = true;  // 스크롤이 맨 왼쪽에 있는지 여부 (이전 화살표 비활성화)
  bool _atEnd = false;   // 스크롤이 맨 오른쪽에 있는지 여부 (다음 화살표 비활성화)

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateArrows); // 스크롤 이벤트 리스너 등록
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateArrows);
    _scrollController.dispose();
    super.dispose();
  }

  // 스크롤 위치를 확인하여 화살표 버튼의 활성/비활성 상태를 업데이트합니다.
  void _updateArrows() {
    final pos = _scrollController.position;
    setState(() {
      _atStart = pos.pixels <= 0;                     // 맨 왼쪽이면 이전 화살표 비활성화
      _atEnd = pos.pixels >= pos.maxScrollExtent;    // 맨 오른쪽이면 다음 화살표 비활성화
    });
  }

  // 화살표 버튼 클릭 시 [delta]만큼 부드럽게 스크롤합니다.
  void _scrollBy(double delta) {
    _scrollController.animateTo(
      (_scrollController.offset + delta).clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // youtubeControllerProvider: AsyncValue<List<YoutubeVideo>> 상태를 반환
    final videosAsync = ref.watch(youtubeControllerProvider);
    final isMobile = Responsive.isMobileDevice;

    return Container(
      color: AppTheme.white,
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 제목
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kYoutubeArrowWidth + 32),
            child: Text('⠿  Youtube Feed', style: AppTheme.mainSectionTitle(isMobile)),
          ),
          const SizedBox(height: 24),
          isMobile
              ? Column(
                  children: [
                    // AsyncValue.when: 로딩/에러/데이터 세 상태를 각각 처리
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
                  height: kYoutubeThumbnailHeight + 140, // 썸네일 + 텍스트 영역 높이
                  child: videosAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, _) => const Center(child: Text('영상을 불러올 수 없습니다.')),
                    data: (videos) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 32),
                        // 이전(←) 화살표 버튼
                        YoutubeArrowButton(direction: YoutubeArrowDirection.prev, disabled: _atStart, onTap: () => _scrollBy(-kYoutubeCardWidth)),
                        // 가로 스크롤 카드 리스트
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: videos.length,
                            itemBuilder: (context, index) => YoutubeCard(video: videos[index]),
                          ),
                        ),
                        // 다음(→) 화살표 버튼
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
