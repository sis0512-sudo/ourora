import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ourora/features/common/utils/constants.dart';
import 'package:ourora/features/works/domain/datasources/works_datasource.dart';
import 'package:ourora/features/works/domain/work_item.dart';

class WorksRemoteDatasource implements WorksDatasource {
  WorksRemoteDatasource({FirebaseFirestore? firestore, FirebaseStorage? storage})
    : _firestore = firestore ?? FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: AppConstants.firestoreDatabaseId),
      _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  @override
  Future<void> uploadWork({
    String? customId,
    required String title,
    required String description,
    required List<({String name, Uint8List bytes})> images,
    required String? youtubeUrl,
    required WorkType type,
    void Function(double progress)? onProgress,
  }) async {
    final docRef = _firestore.collection('works').doc(customId != null && customId.isNotEmpty ? customId : null);
    final id = docRef.id;

    onProgress?.call(0);

    var completedCount = 0;
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

    // Future.wait keeps result ordering the same as the input task list.
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

  String _extractExtension(String fileName) {
    if (!fileName.contains('.')) return 'jpg';
    final ext = fileName.split('.').last.toLowerCase();
    return ext == 'jpeg' ? 'jpg' : ext;
  }

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
      query = query.startAfterDocument(cursor as DocumentSnapshot);
    }
    final snapshot = await query.get();
    final items = snapshot.docs.map((doc) => WorkItem.fromFirestore(doc.data())).toList();
    final nextCursor = snapshot.docs.length == limit ? snapshot.docs.last : null;
    return (items: items, nextCursor: nextCursor);
  }

  @override
  Future<List<WorkItem>> fetchAllWorks({WorkType? type}) async {
    Query<Map<String, dynamic>> query = _firestore.collection('works').orderBy('createdAt', descending: true);
    if (type != null) {
      // where + orderBy on different fields requires a composite index, so filter
      // by type only and sort client-side to avoid the index requirement.
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
