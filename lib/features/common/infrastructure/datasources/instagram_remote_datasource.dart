// Firebase Cloud Functions를 통해 Instagram Graph API를 호출하는 실제 구현체.
// 직접 API를 호출하지 않고 Cloud Functions를 경유하는 이유:
// 브라우저에서 직접 호출 시 CORS 문제와 토큰 노출 위험이 있기 때문입니다.
import 'package:cloud_functions/cloud_functions.dart';
import 'package:ourora/features/common/domain/datasources/instagram_datasource.dart';
import 'package:ourora/features/common/infrastructure/entities/instagram_post.dart';
import 'package:ourora/features/common/utils/constants.dart';

class InstagramRemoteDatasource implements InstagramDatasource {
  final FirebaseFunctions _functions;

  // 의존성 주입(DI) 패턴: 기본값은 실제 Firebase Functions 인스턴스를 사용하고,
  // 테스트 시에는 다른 인스턴스를 주입할 수 있습니다.
  InstagramRemoteDatasource({FirebaseFunctions? functions})
    : _functions = functions ?? FirebaseFunctions.instanceFor(region: AppConstants.firebaseFunctionsRegion);

  @override
  Future<({List<InstagramPost> posts, String? nextCursor})> fetchPage({String? afterCursor, int pageSize = 9}) async {
    // Cloud Functions의 'fetchInstagramPage' 함수를 HTTP Callable로 호출
    final callable = _functions.httpsCallable('fetchInstagramPage');
    final response = await callable.call(<String, dynamic>{'afterCursor': afterCursor, 'pageSize': pageSize});

    // 응답 데이터를 파싱하여 InstagramPost 객체 목록으로 변환
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
