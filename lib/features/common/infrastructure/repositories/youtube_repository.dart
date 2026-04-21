import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ourora/features/common/domain/failures/failure.dart';
import 'package:ourora/features/common/infrastructure/entities/youtube_video.dart';
import 'package:ourora/features/common/utils/utils.dart';

class YoutubeRepository {
  final _firestore = FirebaseFirestore.instanceFor(
    app: FirebaseFirestore.instance.app,
    databaseId: 'ourora',
  );

  Future<Either<Failure, List<YoutubeVideo>>> fetchVideos(List<String> videoIds) async {
    try {
      // 캐시된 데이터 먼저 확인
      final cached = await _getCachedVideos(videoIds);
      if (cached.length == videoIds.length) return right(cached);

      // Firestore에 요청 문서 작성 → Cloud Function 트리거
      final requestRef = await _createFetchRequest(videoIds);

      await _waitForCompletion(requestRef);
      return right(await _getCachedVideos(videoIds));
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Utils.debugLeft(Exception('네트워크가 오프라인이라 YouTube 데이터를 불러올 수 없습니다.'));
      }
      return Utils.debugLeft(e);
    } catch (e) {
      return Utils.debugLeft(e);
    }
  }

  Future<List<YoutubeVideo>> _getCachedVideos(List<String> videoIds) async {
    try {
      final snapshots = await Future.wait(
        videoIds.map((id) => _firestore.collection('youtube_videos').doc(id).get()),
      );
      return snapshots
          .where((snap) => snap.exists)
          .map((snap) => _fromData(snap.data() as Map<String, dynamic>))
          .toList();
    } on FirebaseException catch (e) {
      // 서버 연결이 불가능하면 로컬 캐시만으로 재시도한다.
      if (e.code == 'unavailable') {
        final snapshots = await Future.wait(
          videoIds.map(
            (id) => _firestore.collection('youtube_videos').doc(id).get(const GetOptions(source: Source.cache)),
          ),
        );
        return snapshots
            .where((snap) => snap.exists)
            .map((snap) => _fromData(snap.data() as Map<String, dynamic>))
            .toList();
      }
      rethrow;
    }
  }

  Future<void> _waitForCompletion(DocumentReference<Map<String, dynamic>> ref) async {
    for (int i = 0; i < 15; i++) {
      await Future.delayed(const Duration(seconds: 1));
      final snap = await ref.get();
      final status = snap.data()?['status'] as String?;
      if (status == 'completed') return;
      if (status == 'error') {
        throw Exception(snap.data()?['error'] ?? '알 수 없는 오류');
      }
    }
    throw Exception('YouTube 데이터 로딩 시간 초과');
  }

  Future<DocumentReference<Map<String, dynamic>>> _createFetchRequest(List<String> videoIds) async {
    try {
      return await _firestore.collection('youtube_fetch_requests').add({
        'videoIds': videoIds,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw Exception('Firestore 서버에 연결할 수 없습니다. 네트워크 상태를 확인해 주세요.');
      }
      rethrow;
    }
  }

  YoutubeVideo _fromData(Map<String, dynamic> data) {
    return YoutubeVideo(
      videoId: data['videoId'] as String,
      title: data['title'] as String,
      description: data['description'] as String? ?? '',
      thumbnailUrl: data['thumbnailUrl'] as String,
      duration: data['duration'] as String,
    );
  }
}
