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
import 'package:ourora/features/works/presentation/widgets/works_filter_bar.dart';

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
          const WorksFilterBar(),
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
            style: GoogleFonts.notoSansKr(color: AppTheme.textGray, fontSize: 14),
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
            style: GoogleFonts.notoSansKr(color: AppTheme.textGray, fontSize: 14),
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
          itemBuilder: (context, index) => _WorkGridItem(work: displayed[index]),
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
                          style: GoogleFonts.notoSansKr(
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
