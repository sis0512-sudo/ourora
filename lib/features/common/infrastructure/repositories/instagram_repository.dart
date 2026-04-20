import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:ourora/features/common/domain/failures/failure.dart';
import 'package:ourora/features/common/infrastructure/entities/instagram_post.dart';
import 'package:ourora/features/common/utils/utils.dart';

class InstagramRepository {
  //todo 토큰이랑 userid 바꿔끼우기
  static const String _accessToken =
      'IGAA25DeH3cQpBZAFpiUW4wVFJtbmtwbFVvSjJGYXlmRW5mUHpuOWFhZAk0zZAkFKc2JhN2U2clJjNExKWHFhWUt4TUhCSjlpS1VQQkpNY3Q3ZAlhTWTJnc0w4Ti02ZAHREN0xMdkRFOTNsN19kdVNmNmFTUnVOTWN6RE00S19KbTFkQQZDZD';
  static const _userId = '17841460854096384';
  static const _baseUrl = 'https://graph.instagram.com/$_userId/media';
  static const _fields = 'id,media_type,media_url,thumbnail_url,permalink,timestamp,caption';
  static const int _pageSize = 9;

  Future<Either<Failure, ({List<InstagramPost> posts, String? nextCursor})>> fetchPage({String? afterCursor}) async {
    try {
      final collected = <InstagramPost>[];
      String? cursor = afterCursor;
      bool hasMore = true;

      while (collected.length < _pageSize && hasMore) {
        final params = <String, String>{'fields': _fields, 'access_token': _accessToken, 'limit': '$_pageSize', 'after': ?cursor};

        final uri = Uri.parse(_baseUrl).replace(queryParameters: params);
        final response = await http.get(uri);

        if (response.statusCode != 200) {
          throw Exception('Instagram API error: ${response.statusCode}\n${response.body}');
        }

        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final items = (data['data'] as List<dynamic>).cast<Map<String, dynamic>>();
        final paging = data['paging'] as Map<String, dynamic>?;
        final cursors = paging?['cursors'] as Map<String, dynamic>?;
        hasMore = paging?['next'] != null;
        cursor = hasMore ? (cursors?['after'] as String?) : null;

        final filtered = items.where((item) => item['media_url'] != null && item['media_type'] != 'VIDEO').map(_parsePost);
        collected.addAll(filtered);
      }

      final posts = collected.take(_pageSize).toList();

      return right((posts: posts, nextCursor: cursor));
    } catch (e) {
      return Utils.debugLeft(e);
    }
  }

  InstagramPost _parsePost(Map<String, dynamic> item) {
    return InstagramPost(
      id: item['id'] as String,
      mediaType: item['media_type'] as String,
      mediaUrl: item['media_url'] as String,
      thumbnailUrl: item['thumbnail_url'] as String?,
      permalink: item['permalink'] as String,
      timestamp: DateTime.parse(item['timestamp'] as String),
      caption: item['caption'] as String?,
    );
  }
}
