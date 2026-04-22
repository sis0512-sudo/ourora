import 'package:ourora/features/common/infrastructure/entities/instagram_post.dart';

abstract class InstagramDatasource {
  Future<({List<InstagramPost> posts, String? nextCursor})> fetchPage({String? afterCursor, int pageSize = 9});
}
