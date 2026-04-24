// YouTube 동영상 데이터를 가져오는 인터페이스(추상 클래스).
// 실제 구현체(YoutubeRemoteDatasource)가 이 계약을 따르도록 강제합니다.
import 'package:ourora/features/common/infrastructure/entities/youtube_video.dart';

abstract class YoutubeDatasource {
  // 주어진 YouTube 동영상 ID 목록에 해당하는 영상 정보를 가져옵니다.
  // [videoIds]: 가져올 YouTube 동영상 ID 목록 (예: ['3QSZ5ahBXkY', '08iU4uU0vZg'])
  Future<List<YoutubeVideo>> fetchVideos(List<String> videoIds);
}
