// 작품 데이터 접근의 단일 창구(Repository 패턴).
// Datasource를 직접 호출하는 대신 이 클래스를 통해 데이터를 요청합니다.
import 'dart:typed_data';

import '../domain/datasources/works_datasource.dart';
import '../domain/work_item.dart';
import 'datasources/works_remote_datasource.dart';

class WorksRepository {
  WorksRepository({WorksDatasource? datasource})
    : _datasource = datasource ?? WorksRemoteDatasource();

  final WorksDatasource _datasource;

  // 새 작품을 업로드합니다. 이미지를 Firebase Storage에 저장하고 Firestore에 메타데이터를 저장합니다.
  Future<void> uploadWork({
    String? customId,
    required String title,
    required String description,
    required List<({String name, Uint8List bytes})> images,
    required String? youtubeUrl,
    required WorkType type,
    void Function(double progress)? onProgress,
  }) async {
    await _datasource.uploadWork(
      customId: customId,
      title: title,
      description: description,
      images: images,
      youtubeUrl: youtubeUrl,
      type: type,
      onProgress: onProgress,
    );
  }

  // 작품 목록을 페이지 단위로 가져옵니다 (무한 스크롤용).
  Future<({List<WorkItem> items, Object? nextCursor})> fetchWorksPage({
    Object? cursor,
    int limit = 9,
    WorkType? type,
  }) async {
    return _datasource.fetchWorksPage(cursor: cursor, limit: limit, type: type);
  }

  // 전체 작품 목록을 한 번에 가져옵니다 (타입 필터·검색 기능용).
  Future<List<WorkItem>> fetchAllWorks({WorkType? type}) async {
    return _datasource.fetchAllWorks(type: type);
  }

  // 특정 ID의 작품 상세 정보를 가져옵니다.
  Future<WorkItem?> fetchWorkById(String id) async {
    return _datasource.fetchWorkById(id);
  }
}
