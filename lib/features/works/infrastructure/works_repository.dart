import 'dart:typed_data';

import '../domain/datasources/works_datasource.dart';
import '../domain/work_item.dart';
import 'datasources/works_remote_datasource.dart';

class WorksRepository {
  WorksRepository({WorksDatasource? datasource})
    : _datasource = datasource ?? WorksRemoteDatasource();

  final WorksDatasource _datasource;

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

  Future<({List<WorkItem> items, Object? nextCursor})> fetchWorksPage({
    Object? cursor,
    int limit = 9,
    WorkType? type,
  }) async {
    return _datasource.fetchWorksPage(cursor: cursor, limit: limit, type: type);
  }

  Future<List<WorkItem>> fetchAllWorks({WorkType? type}) async {
    return _datasource.fetchAllWorks(type: type);
  }

  Future<WorkItem?> fetchWorkById(String id) async {
    return _datasource.fetchWorkById(id);
  }
}
