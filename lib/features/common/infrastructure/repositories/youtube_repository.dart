import 'package:fpdart/fpdart.dart';
import 'package:ourora/features/common/domain/datasources/youtube_datasource.dart';
import 'package:ourora/features/common/domain/failures/failure.dart';
import 'package:ourora/features/common/infrastructure/datasources/youtube_remote_datasource.dart';
import 'package:ourora/features/common/infrastructure/entities/youtube_video.dart';
import 'package:ourora/features/common/utils/utils.dart';

class YoutubeRepository {
  final YoutubeDatasource _datasource;

  YoutubeRepository({YoutubeDatasource? datasource})
      : _datasource = datasource ?? YoutubeRemoteDatasource();

  Future<Either<Failure, List<YoutubeVideo>>> fetchVideos(List<String> videoIds) async {
    try {
      final posts = await _datasource.fetchVideos(videoIds);
      return right(posts);
    } catch (e) {
      return Utils.debugLeft(e);
    }
  }
}
