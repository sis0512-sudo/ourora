// 작품 갤러리의 그리드 레이아웃을 구성하는 섹션 위젯.
// 제목·필터바·작품 그리드를 포함하며, 로딩/에러/빈 상태를 각각 처리합니다.
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
    final columns = Responsive.gridColumns(context); // 모바일: 1열, 데스크톱: 3열

    return Container(
      color: AppTheme.white,
      padding: isMobile ? const EdgeInsets.symmetric(horizontal: 32) : const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(title: 'WORKS', isSubTitle: false),
          SizedBox(height: isMobile ? 20 : 40),
          // 타입 필터 버튼 + 검색 입력 필드
          const WorksFilterBar(),
          const SizedBox(height: 32),
          _buildBody(context, state, columns),
        ],
      ),
    );
  }

  // 현재 상태(로딩/에러/데이터)에 따라 적절한 위젯을 반환합니다.
  Widget _buildBody(BuildContext context, WorksState state, int columns) {
    if (state.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60),
          child: CircularProgressIndicator(color: AppTheme.accentOrange, strokeWidth: 2),
        ),
      );
    }

    if (state.error != null && state.works.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: Text('불러올 수 없습니다.', style: GoogleFonts.notoSansKr(color: AppTheme.textGray, fontSize: 14)),
        ),
      );
    }

    // displayedWorks: 검색어가 있으면 필터링된 목록, 없으면 전체 목록
    final displayed = state.displayedWorks;

    if (displayed.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: Text('결과가 없습니다.', style: GoogleFonts.notoSansKr(color: AppTheme.textGray, fontSize: 14)),
        ),
      );
    }

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // 부모 스크롤뷰가 담당
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, crossAxisSpacing: 4, mainAxisSpacing: 4),
          itemCount: displayed.length,
          itemBuilder: (context, index) => _WorkGridItem(work: displayed[index]),
        ),
        // 추가 페이지 로딩 중일 때 하단 스피너 표시
        if (state.isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator(color: AppTheme.accentOrange, strokeWidth: 2)),
          ),
      ],
    );
  }
}

// 그리드의 각 셀(작품 하나)을 표시하는 위젯.
// 호버 시(데스크톱) 어두운 오버레이와 작품 제목이 나타납니다.
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
    // 그리드에는 경량 이미지(lightImageUrls)의 첫 번째 장을 사용합니다.
    final lightImageUrls = widget.work.lightImageUrls.isNotEmpty ? widget.work.lightImageUrls.first : null;
    final isMobile = Responsive.isMobileDevice;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        // 클릭 시 해당 작품의 상세 페이지(/post/:id)로 이동
        onTap: () => context.go(WorkPostScreen.routeFor(widget.work.id)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 썸네일 이미지 (없으면 회색 플레이스홀더)
            if (lightImageUrls != null)
              Image.network(
                lightImageUrls,
                fit: BoxFit.cover,
                cacheWidth: 400,
                cacheHeight: 400,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppTheme.lightGray,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.coral,
                        value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                      ),
                    ),
                  );
                },
              )
            else
              Container(
                color: AppTheme.lightGray,
                child: const Icon(Icons.image_not_supported_outlined, color: AppTheme.borderGray),
              ),
            // 데스크톱 호버 오버레이: 작품 제목과 설명 표시
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
                        style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.white, letterSpacing: 1),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.work.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          widget.work.description,
                          style: GoogleFonts.notoSansKr(fontSize: 12, color: AppTheme.white),
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
