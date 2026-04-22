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
    final cachedVideos = await _fetchCachedVideos(videoIds);
    final cachedById = {for (final video in cachedVideos) video.videoId: video};
    final missingIds = videoIds.where((id) => !cachedById.containsKey(id)).toList();

    if (missingIds.isNotEmpty) {
      final fetchedVideos = await _fetchFromFunctions(missingIds);
      for (final video in fetchedVideos) {
        cachedById[video.videoId] = video;
      }
    }

    return videoIds.where(cachedById.containsKey).map((id) => cachedById[id]!).toList();
  }

  Future<List<YoutubeVideo>> _fetchCachedVideos(List<String> videoIds) async {
    final snapshots = await Future.wait(
      _chunk(videoIds, 10).map((ids) {
        return _firestore.collection('youtube_videos').where(FieldPath.documentId, whereIn: ids).get();
      }),
    );

    return snapshots.expand((s) => s.docs).map(_fromFirestore).toList();
  }

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
        .where((video) => video.videoId.isNotEmpty)
        .toList();
  }

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

  Iterable<List<String>> _chunk(List<String> ids, int size) sync* {
    for (var i = 0; i < ids.length; i += size) {
      final end = (i + size < ids.length) ? i + size : ids.length;
      yield ids.sublist(i, end);
    }
  }
}
