// 작품 상세 페이지의 콘텐츠를 로드하고 표시하는 섹션 위젯.
// FutureProvider.family로 workId별로 개별 캐시를 유지합니다.
// 로딩/에러/데이터 세 가지 상태를 각각 다르게 표시합니다.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/og_updater.dart';
import 'package:ourora/features/works/application/works_controller.dart';
import 'package:ourora/features/works/domain/work_item.dart';
import 'package:ourora/features/works/presentation/widgets/work_post/work_post_back_button.dart';
import 'package:ourora/features/works/presentation/widgets/work_post/work_post_detail_body.dart';

// FutureProvider.family: workId(String)를 키로 하여 작품 상세 데이터를 비동기로 가져옵니다.
// .family를 사용하면 ID별로 별도의 Provider 인스턴스가 생성되고 캐시됩니다.
final _workDetailProvider = FutureProvider.family<WorkItem?, String>((
  ref,
  id,
) async {
  final repo = ref.watch(worksRepositoryProvider);
  return repo.fetchWorkById(id);
});

class WorkPostContentSection extends ConsumerWidget {
  final String workId;

  const WorkPostContentSection({super.key, required this.workId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_workDetailProvider(workId)); // workId에 해당하는 Provider 구독

    // AsyncValue.when: 로딩/에러/데이터 세 상태를 처리하는 편의 메서드
    return async.when(
      // 로딩 중: 중앙에 스피너 표시
      loading: () => const SizedBox(
        height: 400,
        child: Center(
          child: CircularProgressIndicator(
            color: AppTheme.accentOrange,
            strokeWidth: 2,
          ),
        ),
      ),
      // 에러: 불러올 수 없다는 메시지 표시
      error: (e, _) => SizedBox(
        height: 400,
        child: Center(
          child: Text(
            '불러올 수 없습니다.',
            style: GoogleFonts.notoSansKr(fontSize: 14, color: AppTheme.textGray),
          ),
        ),
      ),
      // 데이터 로드 성공
      data: (work) {
        // work == null: 해당 ID의 작품이 Firestore에 존재하지 않는 경우
        if (work == null) {
          return SizedBox(
            height: 400,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '존재하지 않는 작품입니다.',
                    style: GoogleFonts.notoSansKr(fontSize: 16, color: AppTheme.textGray),
                  ),
                  const SizedBox(height: 24),
                  const WorkPostBackButton(),
                ],
              ),
            ),
          );
        }

        // 작품 데이터가 로드되면 해당 작품의 OG 메타 태그를 업데이트합니다.
        // (SNS 공유 시 작품 제목·이미지가 보이도록)
        updateOgMetaForPost(
          id: work.id,
          title: work.title,
          description: work.description,
          image: work.lightImageUrls.isNotEmpty ? work.lightImageUrls.first : null,
        );

        return WorkPostDetailBody(work: work);
      },
    );
  }
}
