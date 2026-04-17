import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourora/features/common/data/youtube_repository.dart';
import 'package:ourora/features/common/domain/youtube_video.dart';
import 'package:ourora/features/common/utils/constants.dart';

final youtubeRepositoryProvider = Provider<YoutubeRepository>(
  (_) => YoutubeRepository(),
);

final youtubeVideosProvider = FutureProvider<List<YoutubeVideo>>((ref) {
  return ref
      .read(youtubeRepositoryProvider)
      .fetchVideos(AppConstants.youtubeVideoIds);
});
