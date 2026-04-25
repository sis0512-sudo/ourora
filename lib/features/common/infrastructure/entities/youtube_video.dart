import 'package:freezed_annotation/freezed_annotation.dart';

part 'youtube_video.freezed.dart';

@freezed
abstract class YoutubeVideo with _$YoutubeVideo {
  const factory YoutubeVideo({
    required String videoId,
    required String title,
    required String description,
    required String thumbnailUrl,
    required String duration,
  }) = _YoutubeVideo;
}
