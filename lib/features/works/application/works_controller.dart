// 작품 목록 페이지의 상태 관리를 담당하는 Riverpod 컨트롤러.
// 페이지네이션(무한 스크롤), 타입 필터, 검색 기능을 통합 관리합니다.
import 'package:ourora/features/works/domain/work_item.dart';
import 'package:ourora/features/works/infrastructure/works_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'works_controller.g.dart';

// 작품 목록 페이지의 현재 상태를 나타내는 불변(immutable) 데이터 클래스.
class WorksState {
  final List<WorkItem> works;    // 현재 로드된 작품 목록
  final bool isLoading;          // 첫 페이지 로딩 중 여부
  final bool isLoadingMore;      // 추가 페이지 로딩 중 여부 (무한 스크롤)
  final bool hasMore;            // 더 불러올 작품이 있는지 여부
  final String? error;           // 에러 메시지
  final Object? cursor;          // 다음 페이지를 불러올 때 사용하는 Firestore 커서
  final WorkType? selectedType;  // 현재 선택된 타입 필터 (null이면 전체)
  final String searchQuery;      // 현재 검색어

  const WorksState({
    this.works = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.error,
    this.cursor,
    this.selectedType,
    this.searchQuery = '',
  });

  // 검색어가 있으면 제목·설명에서 검색어를 포함하는 작품만 반환합니다.
  // 검색어가 없으면 전체 목록을 그대로 반환합니다.
  List<WorkItem> get displayedWorks {
    if (searchQuery.isEmpty) return works;
    final q = searchQuery.toLowerCase();
    return works.where((w) => w.title.toLowerCase().contains(q) || w.description.toLowerCase().contains(q)).toList();
  }

  // 기존 상태를 기반으로 일부 값만 변경한 새 상태를 반환합니다 (불변성 유지).
  WorksState copyWith({
    List<WorkItem>? works,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
    bool clearError = false,
    Object? cursor,
    bool clearCursor = false,
    WorkType? selectedType,
    bool clearSelectedType = false,
    String? searchQuery,
  }) {
    return WorksState(
      works: works ?? this.works,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: clearError ? null : (error ?? this.error),
      cursor: clearCursor ? null : (cursor ?? this.cursor),
      selectedType: clearSelectedType ? null : (selectedType ?? this.selectedType),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// keepAlive: true → 다른 페이지로 이동해도 상태를 유지합니다.
// (홈 화면에서 작품 데이터를 미리 로드해두면 WORKS 페이지 진입 시 즉시 표시)
@Riverpod(keepAlive: true)
WorksRepository worksRepository(Ref ref) => WorksRepository();

@Riverpod(keepAlive: true)
class WorksController extends _$WorksController {
  late WorksRepository _repository;

  @override
  WorksState build() {
    _repository = ref.watch(worksRepositoryProvider);
    Future.microtask(fetch); // 위젯 빌드 직후 첫 페이지 데이터 로드
    return const WorksState();
  }

  // 첫 페이지(또는 필터/정렬 변경 후 전체 새로고침)를 불러옵니다.
  Future<void> fetch() async {
    state = state.copyWith(isLoading: true, clearError: true, clearCursor: true, hasMore: true);
    try {
      final result = await _repository.fetchWorksPage(type: state.selectedType);
      state = state.copyWith(works: result.items, isLoading: false, hasMore: result.nextCursor != null, cursor: result.nextCursor);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // 다음 페이지의 작품을 추가로 불러옵니다 (무한 스크롤).
  // 검색 중이거나 이미 로딩 중이거나 더 불러올 데이터가 없으면 즉시 반환합니다.
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.searchQuery.isNotEmpty) return;
    state = state.copyWith(isLoadingMore: true, clearError: true);
    try {
      final result = await _repository.fetchWorksPage(cursor: state.cursor, type: state.selectedType);
      state = state.copyWith(works: [...state.works, ...result.items], isLoadingMore: false, hasMore: result.nextCursor != null, cursor: result.nextCursor);
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  // 타입 필터를 변경합니다.
  // null(전체): 페이지네이션 모드로 복귀
  // 특정 타입: 해당 타입의 전체 작품을 한 번에 로드 (Firestore 복합 인덱스 없이 클라이언트 정렬)
  Future<void> setType(WorkType? type) async {
    if (state.selectedType == type) return;

    if (type == null) {
      // ALL: revert to paginated mode
      state = state.copyWith(clearSelectedType: true, searchQuery: '', works: [], isLoading: true, clearError: true, clearCursor: true, hasMore: true);
      await fetch();
      return;
    }

    // Specific type: fetch all matching works client-sorted (avoids Firestore composite index)
    state = state.copyWith(selectedType: type, searchQuery: '', works: [], isLoading: true, clearError: true, clearCursor: true, hasMore: false);
    try {
      final items = await _repository.fetchAllWorks(type: state.selectedType);
      state = state.copyWith(works: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // 검색어를 변경합니다.
  // 빈 문자열로 되돌리면 페이지네이션 모드로 복귀합니다.
  // 검색어가 있으면 전체 작품을 로드한 후 클라이언트에서 필터링합니다.
  Future<void> setSearchQuery(String query) async {
    final trimmed = query.trim();
    if (trimmed == state.searchQuery) return;

    if (trimmed.isEmpty) {
      state = state.copyWith(searchQuery: '', works: [], clearCursor: true, hasMore: true);
      await fetch();
      return;
    }

    state = state.copyWith(searchQuery: trimmed, isLoading: true, clearError: true, works: [], hasMore: false);
    try {
      final all = await _repository.fetchAllWorks(type: state.selectedType);
      state = state.copyWith(works: all, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
