// 작품 갤러리의 필터 바 위젯.
// ALL / FURNITURE / ETC 타입 필터 버튼과 검색어 입력 필드로 구성됩니다.
// 타입 필터와 검색이 선택되어 있을 때는 검색 필드를 숨깁니다.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/responsive.dart';
import 'package:ourora/features/works/application/works_controller.dart';
import 'package:ourora/features/works/domain/work_item.dart';

class WorksFilterBar extends ConsumerStatefulWidget {
  const WorksFilterBar({super.key});

  @override
  ConsumerState<WorksFilterBar> createState() => _WorksFilterBarState();
}

class _WorksFilterBarState extends ConsumerState<WorksFilterBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    // 현재 저장된 검색어로 컨트롤러를 초기화합니다 (페이지 재진입 시 상태 복원)
    _searchController = TextEditingController(
      text: ref.read(worksControllerProvider).searchQuery,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 검색 입력 필드에서 Enter 키를 눌렀을 때 호출됩니다.
  void _onSubmit(String value) {
    ref.read(worksControllerProvider.notifier).setSearchQuery(value);
  }

  // 검색어 지우기 버튼(X) 클릭 시 호출됩니다.
  void _onClear() {
    _searchController.clear();
    ref.read(worksControllerProvider.notifier).setSearchQuery('');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(worksControllerProvider);
    final isMobile = Responsive.isMobileDevice;
    // 타입 필터가 없을 때(전체)만 검색 필드를 표시합니다.
    final showSearch = state.selectedType == null;

    // 외부에서 검색어가 초기화되었을 때 (예: 타입 필터 선택 시) 입력 필드도 초기화합니다.
    if (state.searchQuery.isEmpty && _searchController.text.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _searchController.clear();
      });
    }

    final typeButtons = _TypeButtons(selectedType: state.selectedType);
    final searchField = SizedBox(
      width: 240,
      child: _SearchField(
        controller: _searchController,
        onSubmit: _onSubmit,
        onClear: _onClear,
      ),
    );

    // 모바일: Column 배치, 데스크톱: Row 배치(검색 필드는 오른쪽 끝)
    return isMobile
        ? Column(
            children: [
              typeButtons,
              if (showSearch) searchField,
            ],
          )
        : Row(
            children: [
              typeButtons,
              const Spacer(), // 필터와 검색 사이 빈 공간
              if (showSearch) searchField,
            ],
          );
  }
}

// ALL / FURNITURE / ETC 세 개의 필터 칩 버튼을 가로로 배치합니다.
class _TypeButtons extends ConsumerWidget {
  final WorkType? selectedType; // 현재 선택된 타입 (null이면 ALL)

  const _TypeButtons({required this.selectedType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(worksControllerProvider.notifier);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _FilterChip(
          label: 'ALL',
          selected: selectedType == null,
          onTap: () => notifier.setType(null),
        ),
        const SizedBox(width: 8),
        _FilterChip(
          label: 'FURNITURE',
          selected: selectedType == WorkType.furniture,
          onTap: () => notifier.setType(WorkType.furniture),
        ),
        const SizedBox(width: 8),
        _FilterChip(
          label: 'ETC',
          selected: selectedType == WorkType.etc,
          onTap: () => notifier.setType(WorkType.etc),
        ),
      ],
    );
  }
}

// 필터 선택 칩 버튼 하나.
// 선택되었거나 호버 중일 때 coral 색상으로 강조됩니다.
class _FilterChip extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected || _hovered;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: SelectionContainer.disabled(
            child: Text(
              widget.label,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                // 활성화(선택 or 호버) 시 coral, 비활성 시 textGray
                color: active ? AppTheme.coral : AppTheme.textGray,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 검색어를 입력하는 텍스트 필드.
// Enter 키 또는 키보드의 검색 버튼으로 검색을 실행합니다.
// 텍스트가 있을 때만 X 버튼(지우기)이 표시됩니다.
class _SearchField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmit; // Enter 키 입력 시 콜백
  final VoidCallback onClear;          // X 버튼 클릭 시 콜백

  const _SearchField({
    required this.controller,
    required this.onSubmit,
    required this.onClear,
  });

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  @override
  void initState() {
    super.initState();
    // 텍스트 변경 시 X 버튼 표시 여부를 업데이트합니다.
    widget.controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onSubmitted: widget.onSubmit,
      textInputAction: TextInputAction.search, // 키보드에 '검색' 버튼 표시
      style: GoogleFonts.notoSansKr(fontSize: 13, color: AppTheme.black),
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: GoogleFonts.notoSansKr(fontSize: 13, color: AppTheme.borderGray),
        prefixIcon: const Icon(Icons.search, size: 18, color: AppTheme.borderGray),
        // 텍스트가 있을 때만 X(지우기) 버튼을 오른쪽에 표시합니다.
        suffixIcon: widget.controller.text.isNotEmpty
            ? GestureDetector(
                onTap: widget.onClear,
                child: const Icon(Icons.close, size: 16, color: AppTheme.borderGray),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppTheme.borderGray),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppTheme.black), // 포커스 시 검정 테두리
        ),
      ),
    );
  }
}
