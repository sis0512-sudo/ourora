import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:ourora/features/common/domain/failures/failure.dart';
import 'package:ourora/features/common/infrastructure/entities/youtube_video.dart';
import 'package:ourora/features/common/utils/utils.dart';

class YoutubeRepository {
  //todo apikey 서버로 옮기고 정보 저장해놓는 식으로 바꾸기

  static const String youtubeApiKey = 'AIzaSyBxMKAcT5pecsy-2lYrFnjE47PMPWImPHE';
  static const _baseUrl = 'https://www.googleapis.com/youtube/v3/videos';

  Future<Either<Failure, List<YoutubeVideo>>> fetchVideos(List<String> videoIds) async {
    try {
      final ids = videoIds.join(',');
      final uri = Uri.parse('$_baseUrl?id=$ids&part=snippet,contentDetails&key=${youtubeApiKey}');

      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception('YouTube API error: ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>;

      // API는 요청 순서를 보장하지 않으므로 ID 순으로 정렬
      final Map<String, YoutubeVideo> byId = {for (final item in items) item['id'] as String: _parseItem(item)};

      return right(videoIds.where(byId.containsKey).map((id) => byId[id]!).toList());
    } catch (e) {
      return Utils.debugLeft(e);
    }
  }

  YoutubeVideo _parseItem(Map<String, dynamic> item) {
    final snippet = item['snippet'] as Map<String, dynamic>;
    final contentDetails = item['contentDetails'] as Map<String, dynamic>;
    final thumbnails = snippet['thumbnails'] as Map<String, dynamic>;
    final thumbnail = (thumbnails['high'] ?? thumbnails['medium'] ?? thumbnails['default']) as Map<String, dynamic>;

    return YoutubeVideo(
      videoId: item['id'] as String,
      title: snippet['title'] as String,
      description: snippet['description'] as String? ?? '',
      thumbnailUrl: thumbnail['url'] as String,
      duration: _parseDuration(contentDetails['duration'] as String),
    );
  }

  String _parseDuration(String iso) {
    final match = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?').firstMatch(iso);
    if (match == null) return '00:00';

    final h = int.tryParse(match.group(1) ?? '') ?? 0;
    final m = int.tryParse(match.group(2) ?? '') ?? 0;
    final s = int.tryParse(match.group(3) ?? '') ?? 0;

    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
