import 'dart:typed_data';

import 'package:ourora/features/works/domain/work_item.dart';

abstract class WorksDatasource {
  Future<void> uploadWork({
    String? customId,
    required String title,
    required String description,
    required List<({String name, Uint8List bytes})> images,
    required String? youtubeUrl,
    required WorkType type,
    void Function(double progress)? onProgress,
  });

  Future<({List<WorkItem> items, Object? nextCursor})> fetchWorksPage({
    Object? cursor,
    int limit = 9,
  });
}
