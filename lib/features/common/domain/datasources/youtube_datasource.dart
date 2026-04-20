import 'package:ourora/features/common/infrastructure/entities/youtube_video.dart';

abstract class YoutubeDatasource {
  Future<List<YoutubeVideo>> fetchVideos(List<String> videoIds);
}
