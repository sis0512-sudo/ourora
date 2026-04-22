import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/title_widget.dart';
import 'package:ourora/features/common/utils/responsive.dart';
import 'package:ourora/features/works/application/works_controller.dart';
import 'package:ourora/features/works/domain/work_item.dart';

class WorksGridSection extends ConsumerWidget {
  const WorksGridSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(worksControllerProvider);
    final columns = Responsive.gridColumns(context);

    return Container(
      color: AppTheme.white,
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(title: 'WORKS', isSubTitle: false),
          const SizedBox(height: 40),
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
          child: CircularProgressIndicator(color: AppTheme.accentOrange, strokeWidth: 2),
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: Text(
            '불러올 수 없습니다.',
            style: TextStyle(color: AppTheme.textGray, fontSize: 14, fontFamily: 'NanumGothic'),
          ),
        ),
      );
    }

    if (state.works.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, crossAxisSpacing: 4, mainAxisSpacing: 4),
      itemCount: state.works.length,
      itemBuilder: (context, index) => _WorkGridItem(work: state.works[index]),
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
    final lightImageUrls = widget.work.lightImageUrls.isNotEmpty ? widget.work.lightImageUrls.first : null;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (lightImageUrls != null)
            CachedNetworkImage(
              imageUrl: lightImageUrls,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppTheme.lightGray,
                child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.accentOrange)),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppTheme.lightGray,
                child: const Icon(Icons.broken_image_outlined, color: AppTheme.borderGray),
              ),
            )
          else
            Container(
              color: AppTheme.lightGray,
              child: const Icon(Icons.image_not_supported_outlined, color: AppTheme.borderGray),
            ),
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
                    style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.white, letterSpacing: 1),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.work.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      widget.work.description,
                      style: const TextStyle(fontFamily: 'NanumGothic', fontSize: 12, color: AppTheme.white),
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
    );
  }
}
