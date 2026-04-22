import 'package:cloud_functions/cloud_functions.dart';
import 'package:ourora/features/common/domain/datasources/instagram_datasource.dart';
import 'package:ourora/features/common/infrastructure/entities/instagram_post.dart';
import 'package:ourora/features/common/utils/constants.dart';

class InstagramRemoteDatasource implements InstagramDatasource {
  final FirebaseFunctions _functions;

  InstagramRemoteDatasource({FirebaseFunctions? functions})
    : _functions = functions ?? FirebaseFunctions.instanceFor(region: AppConstants.firebaseFunctionsRegion);

  @override
  Future<({List<InstagramPost> posts, String? nextCursor})> fetchPage({String? afterCursor, int pageSize = 9}) async {
    final callable = _functions.httpsCallable('fetchInstagramPage');
    final response = await callable.call(<String, dynamic>{'afterCursor': afterCursor, 'pageSize': pageSize});

    final data = response.data as Map<dynamic, dynamic>;
    final rawPosts = (data['posts'] as List<dynamic>? ?? const []);
    final posts = rawPosts
        .cast<Map<dynamic, dynamic>>()
        .map(
          (item) => InstagramPost(
            id: (item['id'] as String?) ?? '',
            mediaType: (item['mediaType'] as String?) ?? '',
            mediaUrl: (item['mediaUrl'] as String?) ?? '',
            thumbnailUrl: item['thumbnailUrl'] as String?,
            permalink: (item['permalink'] as String?) ?? '',
            timestamp: DateTime.tryParse((item['timestamp'] as String?) ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
            caption: item['caption'] as String?,
          ),
        )
        .toList();

    final nextCursor = data['nextCursor'] as String?;
    return (posts: posts, nextCursor: nextCursor);
  } // 특정 폴더의 모든 파일 URL 가져오기
}
