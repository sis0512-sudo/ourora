// YouTube 영상 정보를 Firestore 캐시 → Cloud Functions 순서로 가져오는 실제 구현체.
// 먼저 Firestore에서 캐시된 데이터를 조회하고,
// 없는 영상만 Cloud Functions를 통해 YouTube API에서 가져옵니다.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ourora/features/common/domain/datasources/youtube_datasource.dart';
import 'package:ourora/features/common/infrastructure/entities/youtube_video.dart';
import 'package:ourora/features/common/utils/constants.dart';

class YoutubeRemoteDatasource implements YoutubeDatasource {
  YoutubeRemoteDatasource({FirebaseFirestore? firestore, FirebaseFunctions? functions})
    : _firestore = firestore ?? FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: AppConstants.firestoreDatabaseId),
      _functions = functions ?? FirebaseFunctions.instanceFor(region: AppConstants.firebaseFunctionsRegion);

  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  @override
  Future<List<YoutubeVideo>> fetchVideos(List<String> videoIds) async {
    // 1단계: Firestore 캐시에서 이미 저장된 영상 정보를 가져옵니다.
    final cachedVideos = await _fetchCachedVideos(videoIds);
    final cachedById = {for (final video in cachedVideos) video.videoId: video};

    // 2단계: 캐시에 없는 영상 ID만 추려냅니다.
    final missingIds = videoIds.where((id) => !cachedById.containsKey(id)).toList();

    if (missingIds.isNotEmpty) {
      // 3단계: 캐시에 없는 영상만 Cloud Functions를 통해 YouTube API에서 가져옵니다.
      final fetchedVideos = await _fetchFromFunctions(missingIds);
      for (final video in fetchedVideos) {
        cachedById[video.videoId] = video;
      }
    }

    // 원래 요청한 순서(videoIds 순서)대로 결과를 반환합니다.
    return videoIds.where(cachedById.containsKey).map((id) => cachedById[id]!).toList();
  }

  // Firestore의 'youtube_videos' 컬렉션에서 영상 정보를 일괄 조회합니다.
  // Firestore whereIn은 최대 10개까지 지원하므로 _chunk()로 분할하여 병렬 처리합니다.
  Future<List<YoutubeVideo>> _fetchCachedVideos(List<String> videoIds) async {
    final snapshots = await Future.wait(
      _chunk(videoIds, 10).map((ids) {
        return _firestore.collection('youtube_videos').where(FieldPath.documentId, whereIn: ids).get();
      }),
    );

    return snapshots.expand((s) => s.docs).map(_fromFirestore).toList();
  }

  // Cloud Functions의 'fetchYoutubeVideosCallable' 함수를 호출하여 YouTube API 데이터를 가져옵니다.
  Future<List<YoutubeVideo>> _fetchFromFunctions(List<String> videoIds) async {
    final callable = _functions.httpsCallable('fetchYoutubeVideosCallable');
    final response = await callable.call(<String, dynamic>{'videoIds': videoIds});

    final data = response.data as Map<dynamic, dynamic>? ?? const {};
    final rawVideos = (data['videos'] as List<dynamic>? ?? const []);
    return rawVideos
        .cast<Map<dynamic, dynamic>>()
        .map(
          (item) => YoutubeVideo(
            videoId: (item['videoId'] as String?) ?? '',
            title: (item['title'] as String?) ?? '',
            description: (item['description'] as String?) ?? '',
            thumbnailUrl: (item['thumbnailUrl'] as String?) ?? '',
            duration: (item['duration'] as String?) ?? '00:00',
          ),
        )
        .where((video) => video.videoId.isNotEmpty) // 잘못된 데이터 필터링
        .toList();
  }

  // Firestore 문서 스냅샷을 YoutubeVideo 객체로 변환합니다.
  YoutubeVideo _fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return YoutubeVideo(
      videoId: doc.id,
      title: (data['title'] as String?) ?? '',
      description: (data['description'] as String?) ?? '',
      thumbnailUrl: (data['thumbnailUrl'] as String?) ?? '',
      duration: (data['duration'] as String?) ?? '00:00',
    );
  }

  // 리스트를 [size] 크기의 청크(묶음)로 나눕니다.
  // 예: [1,2,3,4,5], size=2 → [[1,2],[3,4],[5]]
  Iterable<List<String>> _chunk(List<String> ids, int size) sync* {
    for (var i = 0; i < ids.length; i += size) {
      final end = (i + size < ids.length) ? i + size : ids.length;
      yield ids.sublist(i, end);
    }
  }
}
