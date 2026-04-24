// Works 기능의 실제 데이터 접근 구현체.
// Firestore에서 작품 목록/상세를 읽고, Firebase Storage에 이미지를 업로드합니다.
// WorksDatasource 인터페이스를 구현하여 리포지토리가 이 클래스에 의존합니다.
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ourora/features/common/utils/constants.dart';
import 'package:ourora/features/works/domain/datasources/works_datasource.dart';
import 'package:ourora/features/works/domain/work_item.dart';

class WorksRemoteDatasource implements WorksDatasource {
  // 의존성 주입(DI): 기본값은 Firebase 인스턴스, 테스트 시에는 mock 전달 가능
  WorksRemoteDatasource({FirebaseFirestore? firestore, FirebaseStorage? storage})
    : _firestore = firestore ?? FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: AppConstants.firestoreDatabaseId),
      _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  @override
  // 새 작품을 Storage에 이미지 업로드 후 Firestore에 저장합니다.
  // onProgress 콜백으로 업로드 진행률(0.0~1.0)을 UI에 전달할 수 있습니다.
  Future<void> uploadWork({
    String? customId,
    required String title,
    required String description,
    required List<({String name, Uint8List bytes})> images,
    required String? youtubeUrl,
    required WorkType type,
    void Function(double progress)? onProgress,
  }) async {
    // customId가 비어있으면 Firestore가 자동으로 ID를 생성합니다
    final docRef = _firestore.collection('works').doc(customId != null && customId.isNotEmpty ? customId : null);
    final id = docRef.id;

    onProgress?.call(0);

    var completedCount = 0;
    // 이미지 파일들을 병렬로 Storage에 업로드하고 다운로드 URL을 받아옵니다
    final uploadTasks = images.asMap().entries.map((entry) async {
      final index = entry.key;
      final image = entry.value;
      final ext = _extractExtension(image.name);
      final ref = _storage.ref('works/$id/image_$index.$ext');
      final metadata = SettableMetadata(contentType: _contentTypeForExtension(ext));
      await ref.putData(image.bytes, metadata);
      final url = await ref.getDownloadURL();
      completedCount += 1;
      onProgress?.call(completedCount / images.length);
      return url;
    }).toList();

    // Future.wait: 모든 업로드가 완료될 때까지 대기, 입력 순서대로 URL 반환
    final imageUrls = await Future.wait(uploadTasks);

    final item = WorkItem(
      id: id,
      title: title,
      description: description,
      imageUrls: imageUrls,
      lightImageUrls: imageUrls,
      youtubeUrl: youtubeUrl?.isEmpty == true ? null : youtubeUrl,
      type: type,
      createdAt: DateTime.now(),
    );

    await docRef.set(item.toFirestore());
  }

  // 파일명에서 확장자를 추출합니다 (jpeg는 jpg로 통일)
  String _extractExtension(String fileName) {
    if (!fileName.contains('.')) return 'jpg';
    final ext = fileName.split('.').last.toLowerCase();
    return ext == 'jpeg' ? 'jpg' : ext;
  }

  // 확장자를 MIME 타입 문자열로 변환합니다 (Firebase Storage 업로드 시 필요)
  String _contentTypeForExtension(String ext) {
    switch (ext) {
      case 'jpg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      case 'bmp':
        return 'image/bmp';
      case 'heic':
        return 'image/heic';
      case 'heif':
        return 'image/heif';
      default:
        return 'application/octet-stream';
    }
  }

  @override
  // 작품 목록을 페이지 단위로 가져옵니다 (무한 스크롤 지원).
  // cursor는 이전 페이지의 마지막 DocumentSnapshot이며, 다음 페이지의 시작점이 됩니다.
  Future<({List<WorkItem> items, Object? nextCursor})> fetchWorksPage({
    Object? cursor,
    int limit = 9,
    WorkType? type,
  }) async {
    var query = _firestore.collection('works').orderBy('createdAt', descending: true).limit(limit);
    if (type != null) {
      query = _firestore.collection('works').where('type', isEqualTo: type.name).orderBy('createdAt', descending: true).limit(limit);
    }
    if (cursor != null) {
      // startAfterDocument: cursor 문서 다음부터 조회 (Firestore 커서 페이지네이션)
      query = query.startAfterDocument(cursor as DocumentSnapshot);
    }
    final snapshot = await query.get();
    final items = snapshot.docs.map((doc) => WorkItem.fromFirestore(doc.data())).toList();
    // 결과가 limit와 같으면 다음 페이지가 있다고 판단, 마지막 문서를 커서로 저장
    final nextCursor = snapshot.docs.length == limit ? snapshot.docs.last : null;
    return (items: items, nextCursor: nextCursor);
  }

  @override
  // 특정 ID의 작품 하나를 Firestore에서 조회합니다. 없으면 null 반환.
  Future<WorkItem?> fetchWorkById(String id) async {
    final doc = await _firestore.collection('works').doc(id).get();
    if (!doc.exists) return null;
    return WorkItem.fromFirestore(doc.data()!);
  }

  @override
  // 모든 작품을 한 번에 가져옵니다 (검색 기능용).
  // type 필터가 있을 때는 복합 인덱스 없이도 동작하도록 클라이언트 측 정렬을 사용합니다.
  Future<List<WorkItem>> fetchAllWorks({WorkType? type}) async {
    Query<Map<String, dynamic>> query = _firestore.collection('works').orderBy('createdAt', descending: true);
    if (type != null) {
      // where + orderBy가 서로 다른 필드면 Firestore 복합 인덱스가 필요하므로
      // type 필터만 Firestore에 적용하고 날짜 정렬은 클라이언트에서 처리합니다
      query = _firestore.collection('works').where('type', isEqualTo: type.name);
    }
    final snapshot = await query.get();
    final items = snapshot.docs.map((doc) => WorkItem.fromFirestore(doc.data())).toList();
    if (type != null) {
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return items;
  }
}
