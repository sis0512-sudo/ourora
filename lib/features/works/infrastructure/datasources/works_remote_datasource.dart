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

    final imageUrls = <String>[];
    for (var i = 0; i < images.length; i++) {
      final image = images[i];
      final ext = image.name.contains('.') ? image.name.split('.').last.toLowerCase() : 'jpg';
      final ref = _storage.ref('works/$id/image_$i.$ext');
      await ref.putData(image.bytes, SettableMetadata(contentType: 'image/$ext'));
      final url = await ref.getDownloadURL();
      imageUrls.add(url);
      onProgress?.call((i + 1) / images.length);
    }

    final item = WorkItem(
      id: id,
      title: title,
      description: description,
      imageUrls: imageUrls,
      youtubeUrl: youtubeUrl?.isEmpty == true ? null : youtubeUrl,
      type: type,
      createdAt: DateTime.now(),
    );

    await docRef.set(item.toFirestore());
  }

  @override
  Future<List<WorkItem>> fetchWorks() async {
    final snapshot = await _firestore.collection('works').orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => WorkItem.fromFirestore(doc.data())).toList();
  }
}
