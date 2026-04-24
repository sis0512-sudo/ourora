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
    _searchController = TextEditingController(
      text: ref.read(worksControllerProvider).searchQuery,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSubmit(String value) {
    ref.read(worksControllerProvider.notifier).setSearchQuery(value);
  }

  void _onClear() {
    _searchController.clear();
    ref.read(worksControllerProvider.notifier).setSearchQuery('');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(worksControllerProvider);
    final isMobile = Responsive.isMobileDevice;
    final showSearch = state.selectedType == null;

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
              const Spacer(),
              if (showSearch) searchField,
            ],
          );
  }
}

class _TypeButtons extends ConsumerWidget {
  final WorkType? selectedType;

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
                color: active ? AppTheme.coral : AppTheme.textGray,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmit;
  final VoidCallback onClear;

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
      textInputAction: TextInputAction.search,
      style: const TextStyle(
        fontFamily: 'Noto Sans KR',
        fontSize: 13,
        color: AppTheme.black,
      ),
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: const TextStyle(
          fontFamily: 'Noto Sans KR',
          fontSize: 13,
          color: AppTheme.borderGray,
        ),
        prefixIcon: const Icon(
          Icons.search,
          size: 18,
          color: AppTheme.borderGray,
        ),
        suffixIcon: widget.controller.text.isNotEmpty
            ? GestureDetector(
                onTap: widget.onClear,
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: AppTheme.borderGray,
                ),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 12,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppTheme.borderGray),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppTheme.black),
        ),
      ),
    );
  }
}
