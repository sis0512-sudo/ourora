import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/title_widget.dart';
import 'package:ourora/features/common/utils/responsive.dart';
import 'package:ourora/features/works/application/works_controller.dart';
import 'package:ourora/features/works/domain/work_item.dart';
import 'package:ourora/features/works/presentation/screens/work_post_screen.dart';

class WorksGridSection extends ConsumerWidget {
  const WorksGridSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = Responsive.isMobileDevice;
    final state = ref.watch(worksControllerProvider);
    final columns = Responsive.gridColumns(context);

    return Container(
      color: AppTheme.white,
      padding: isMobile
          ? const EdgeInsets.symmetric(horizontal: 32)
          : const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(title: 'WORKS', isSubTitle: false),
          SizedBox(height: isMobile ? 20 : 40),
          _FilterBar(
            selectedType: state.selectedType,
            searchQuery: state.searchQuery,
          ),
          const SizedBox(height: 32),
          _buildBody(context, state, columns),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, WorksState state, int columns) {
    if (state.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60),
          child: CircularProgressIndicator(
            color: AppTheme.accentOrange,
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (state.error != null && state.works.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: Text(
            '불러올 수 없습니다.',
            style: const TextStyle(
              color: AppTheme.textGray,
              fontSize: 14,
              fontFamily: 'Noto Sans KR',
            ),
          ),
        ),
      );
    }

    final displayed = state.displayedWorks;

    if (displayed.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: Text(
            '결과가 없습니다.',
            style: const TextStyle(
              color: AppTheme.textGray,
              fontSize: 14,
              fontFamily: 'Noto Sans KR',
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: displayed.length,
          itemBuilder: (context, index) =>
              _WorkGridItem(work: displayed[index]),
        ),
        if (state.isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: CircularProgressIndicator(
                color: AppTheme.accentOrange,
                strokeWidth: 2,
              ),
            ),
          ),
      ],
    );
  }
}

class _FilterBar extends ConsumerStatefulWidget {
  final WorkType? selectedType;
  final String searchQuery;

  const _FilterBar({required this.selectedType, required this.searchQuery});

  @override
  ConsumerState<_FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends ConsumerState<_FilterBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(_FilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery &&
        widget.searchQuery.isEmpty &&
        _searchController.text.isNotEmpty) {
      _searchController.clear();
    }
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
    final isMobile = Responsive.isMobileDevice;
    final showSearch = widget.selectedType == null;

    return isMobile
        ? Column(
            children: [
              _TypeButtons(selectedType: widget.selectedType),
              if (showSearch)
                SizedBox(
                  width: 240,
                  child: _SearchField(
                    controller: _searchController,
                    onSubmit: _onSubmit,
                    onClear: _onClear,
                  ),
                ),
            ],
          )
        : Row(
            children: [
              _TypeButtons(selectedType: widget.selectedType),
              const Spacer(),
              if (showSearch)
                SizedBox(
                  width: 240,
                  child: _SearchField(
                    controller: _searchController,
                    onSubmit: _onSubmit,
                    onClear: _onClear,
                  ),
                ),
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
                color: (widget.selected || active)
                    ? AppTheme.coral
                    : AppTheme.textGray,
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

class _WorkGridItem extends StatefulWidget {
  final WorkItem work;

  const _WorkGridItem({required this.work});

  @override
  State<_WorkGridItem> createState() => _WorkGridItemState();
}

class _WorkGridItemState extends State<_WorkGridItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final lightImageUrls = widget.work.lightImageUrls.isNotEmpty
        ? widget.work.lightImageUrls.first
        : null;
    final isMobile = Responsive.isMobileDevice;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go(WorkPostScreen.routeFor(widget.work.id)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (lightImageUrls != null)
              Image.network(
                lightImageUrls,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppTheme.lightGray,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.coral,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              )
            else
              Container(
                color: AppTheme.lightGray,
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  color: AppTheme.borderGray,
                ),
              ),
            if (!isMobile)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _hovered ? 1.0 : 0.0,
                child: Container(
                  color: AppTheme.black.withValues(alpha: 0.65),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.work.title,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.white,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.work.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          widget.work.description,
                          style: const TextStyle(
                            fontFamily: 'Noto Sans KR',
                            fontSize: 12,
                            color: AppTheme.white,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
