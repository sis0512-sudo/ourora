import 'package:ourora/features/common/infrastructure/entities/instagram_post.dart';
import 'package:ourora/features/common/infrastructure/repositories/instagram_repository.dart';
import 'package:ourora/features/common/utils/instagram_seed.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'instagram_controller.g.dart';

class InstagramFeedState {
  final List<InstagramPost> posts;
  final bool isLoading;      // Load More 페이지네이션 로딩
  final bool isRefreshing;   // 시드 데이터 → 최신 데이터 백그라운드 교체 중
  final bool hasMore;
  final String? nextCursor;
  final String? error;

  const InstagramFeedState({
    this.posts = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.hasMore = true,
    this.nextCursor,
    this.error,
  });

  InstagramFeedState copyWith({
    List<InstagramPost>? posts,
    bool? isLoading,
    bool? isRefreshing,
    bool? hasMore,
    String? nextCursor,
    String? error,
    bool clearError = false,
    bool clearCursor = false,
  }) {
    return InstagramFeedState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
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
  InstagramFeedState build(int pageSize) {
    _repository = ref.watch(instagramRepositoryProvider);

    final seed = instagramSeedPosts;
    if (seed.isNotEmpty) {
      // 시드 데이터가 있으면 즉시 표시하고 백그라운드에서 최신 데이터로 교체
      Future.microtask(() => _refreshFromSeed(pageSize));
      return InstagramFeedState(posts: seed, isRefreshing: true, hasMore: true);
    }

    // 시드 데이터가 없으면 기존 방식대로 로딩
    Future.microtask(loadMore);
    return const InstagramFeedState();
  }

  // 시드 데이터를 보여주는 동안 백그라운드에서 첫 페이지를 새로 fetch 합니다.
  // 성공하면 시드 데이터를 최신 데이터로 교체하고, 실패하면 시드 데이터를 유지합니다.
  Future<void> _refreshFromSeed(int pageSize) async {
    final result = await _repository.fetchPage(pageSize: pageSize);
    result.fold(
      (failure) => state = state.copyWith(isRefreshing: false),
      (page) => state = InstagramFeedState(
        posts: page.posts.take(pageSize).toList(),
        hasMore: page.nextCursor != null,
        nextCursor: page.nextCursor,
      ),
    );
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isRefreshing || !state.hasMore) return;

    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.fetchPage(afterCursor: state.nextCursor, pageSize: pageSize);
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.error),
      (page) => state = state.copyWith(
        posts: [...state.posts, ...page.posts.take(pageSize)],
        isLoading: false,
        hasMore: page.nextCursor != null,
        nextCursor: page.nextCursor,
        clearCursor: page.nextCursor == null,
      ),
    );
  }
}
