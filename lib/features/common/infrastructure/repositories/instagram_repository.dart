import 'dart:convert';
import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:ourora/features/common/domain/failures/failure.dart';
import 'package:ourora/features/common/infrastructure/entities/instagram_post.dart';
import 'package:ourora/features/common/utils/constants.dart';
import 'package:ourora/features/common/utils/utils.dart';

class InstagramRepository {
  static const _baseUrl = 'https://graph.facebook.com/v25.0/17841460854096384/media';
  static const _fields = 'id,media_type,media_url,thumbnail_url,permalink,timestamp';

  Future<Either<Failure, ({List<InstagramPost> posts, String? nextCursor})>> fetchPage({
    String? afterCursor,
  }) async {
    try {
      final params = <String, String>{
        'fields': _fields,
        'access_token': AppConstants.instagramAccessToken,
        if (afterCursor != null) 'after': afterCursor,
      };

      final uri = Uri.parse(_baseUrl).replace(queryParameters: params);
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('Instagram API error: ${response.statusCode}\n${response.body}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final items = (data['data'] as List<dynamic>).cast<Map<String, dynamic>>();
      final paging = data['paging'] as Map<String, dynamic>?;
      final cursors = paging?['cursors'] as Map<String, dynamic>?;
      final hasNext = paging?['next'] != null;
      final String? nextCursor = hasNext ? (cursors?['after'] as String?) : null;

      final posts = items.map(_parsePost).toList();
      log('[InstagramRepository] fetchPage: ${posts.length} posts, nextCursor=$nextCursor');

      return right((posts: posts, nextCursor: nextCursor));
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
    );
  }
}
