import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ourora/features/common/domain/instagram_post.dart';
import 'package:ourora/features/common/utils/constants.dart';

class InstagramPage {
  final List<InstagramPost> posts;
  final String? nextCursor;

  const InstagramPage({required this.posts, this.nextCursor});
}

class InstagramRepository {
  static const _baseUrl = 'https://graph.instagram.com/v21.0/me/media';
  static const _fields =
      'id,media_type,media_url,thumbnail_url,permalink,timestamp';

  Future<InstagramPage> fetchPage({String? afterCursor}) async {
    final params = <String, String>{
      'fields': _fields,
      'limit': '9',
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

    return InstagramPage(
      posts: items.map(_parsePost).toList(),
      nextCursor: nextCursor,
    );
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
