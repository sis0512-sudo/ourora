import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:ourora/features/common/domain/failures/failure.dart';
import 'package:ourora/features/common/infrastructure/entities/youtube_video.dart';
import 'package:ourora/features/common/utils/utils.dart';

class YoutubeRepository {
  Future<Either<Failure, List<YoutubeVideo>>> fetchVideos(List<String> videoIds) async {
    try {
      final posts = await Future.wait(videoIds.map(_fetchVideo));
      return right(posts);
    } catch (e) {
      return Utils.debugLeft(e);
    }
  }

  Future<YoutubeVideo> _fetchVideo(String videoId) async {
    final url = Uri.parse(
      'https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=$videoId&format=json',
    );
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('YouTube oEmbed 오류: ${response.statusCode}');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return YoutubeVideo(
      videoId: videoId,
      title: data['title'] as String? ?? '',
      description: '',
      thumbnailUrl: data['thumbnail_url'] as String? ?? '',
      duration: '00:00',
    );
  }
}
