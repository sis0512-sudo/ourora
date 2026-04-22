import 'package:fpdart/fpdart.dart';
import 'package:ourora/features/common/domain/datasources/instagram_datasource.dart';
import 'package:ourora/features/common/domain/failures/failure.dart';
import 'package:ourora/features/common/infrastructure/datasources/instagram_remote_datasource.dart';
import 'package:ourora/features/common/infrastructure/entities/instagram_post.dart';
import 'package:ourora/features/common/utils/utils.dart';

class InstagramRepository {
  final InstagramDatasource _datasource;

  InstagramRepository({InstagramDatasource? datasource}) : _datasource = datasource ?? InstagramRemoteDatasource();

  Future<Either<Failure, ({List<InstagramPost> posts, String? nextCursor})>> fetchPage({String? afterCursor, int pageSize = 9}) async {
    try {
      final page = await _datasource.fetchPage(afterCursor: afterCursor, pageSize: pageSize);
      return right(page);
    } catch (e) {
      return Utils.debugLeft(e);
    }
  }
}
