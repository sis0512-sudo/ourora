import 'package:ourora/features/common/infrastructure/entities/instagram_post.dart';
import 'package:ourora/features/common/infrastructure/repositories/instagram_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'instagram_controller.g.dart';

class InstagramFeedState {
  final List<InstagramPost> posts;
  final bool isLoading;
  final bool hasMore;
  final String? nextCursor;
  final String? error;

  const InstagramFeedState({
    this.posts = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.nextCursor,
    this.error,
  });

  InstagramFeedState copyWith({
    List<InstagramPost>? posts,
    bool? isLoading,
    bool? hasMore,
    String? nextCursor,
    String? error,
    bool clearError = false,
    bool clearCursor = false,
  }) {
    return InstagramFeedState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: clearCursor ? null : (nextCursor ?? this.nextCursor),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

@riverpod
InstagramRepository instagramRepository(Ref ref) => InstagramRepository();

@riverpod
class InstagramController extends _$InstagramController {
  late InstagramRepository _repository;

  @override
  InstagramFeedState build() {
    _repository = ref.watch(instagramRepositoryProvider);
    Future.microtask(loadMore);
    return const InstagramFeedState();
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.fetchPage(afterCursor: state.nextCursor);
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.error),
      (page) => state = state.copyWith(
        posts: [...state.posts, ...page.posts],
        isLoading: false,
        hasMore: page.nextCursor != null,
        nextCursor: page.nextCursor,
        clearCursor: page.nextCursor == null,
      ),
    );
  }
}
