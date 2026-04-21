import 'package:cloud_functions/cloud_functions.dart';
import 'package:ourora/features/common/domain/datasources/instagram_datasource.dart';
import 'package:ourora/features/common/infrastructure/entities/instagram_post.dart';

class InstagramFunctionsDatasource implements InstagramDatasource {
  final FirebaseFunctions _functions;

  InstagramFunctionsDatasource({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instanceFor(region: 'asia-northeast3');

  @override
  Future<({List<InstagramPost> posts, String? nextCursor})> fetchPage({String? afterCursor}) async {
    final callable = _functions.httpsCallable('fetchInstagramPage');
    final response = await callable.call(<String, dynamic>{'afterCursor': afterCursor});

    final data = response.data as Map<dynamic, dynamic>;
    final rawPosts = (data['posts'] as List<dynamic>? ?? const []);
    final posts = rawPosts
        .cast<Map<dynamic, dynamic>>()
        .map((item) => InstagramPost(
              id: (item['id'] as String?) ?? '',
              mediaType: (item['mediaType'] as String?) ?? '',
              mediaUrl: (item['mediaUrl'] as String?) ?? '',
              thumbnailUrl: item['thumbnailUrl'] as String?,
              permalink: (item['permalink'] as String?) ?? '',
              timestamp: DateTime.tryParse((item['timestamp'] as String?) ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
              caption: item['caption'] as String?,
            ))
        .toList();

    final nextCursor = data['nextCursor'] as String?;
    return (posts: posts, nextCursor: nextCursor);
  }
}
