import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourora/features/common/data/instagram_repository.dart';
import 'package:ourora/features/common/domain/instagram_post.dart';

final instagramRepositoryProvider = Provider<InstagramRepository>(
  (_) => InstagramRepository(),
);

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

class InstagramFeedNotifier extends Notifier<InstagramFeedState> {
  @override
  InstagramFeedState build() {
    Future.microtask(loadMore);
    return const InstagramFeedState();
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repo = ref.read(instagramRepositoryProvider);
      final page = await repo.fetchPage(afterCursor: state.nextCursor);
      state = state.copyWith(
        posts: [...state.posts, ...page.posts],
        isLoading: false,
        hasMore: page.nextCursor != null,
        nextCursor: page.nextCursor,
        clearCursor: page.nextCursor == null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final instagramFeedProvider =
    NotifierProvider<InstagramFeedNotifier, InstagramFeedState>(
  InstagramFeedNotifier.new,
);
