import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/og_updater.dart';
import 'package:ourora/features/works/application/works_controller.dart';
import 'package:ourora/features/works/domain/work_item.dart';
import 'package:ourora/features/works/presentation/widgets/work_post/work_post_back_button.dart';
import 'package:ourora/features/works/presentation/widgets/work_post/work_post_detail_body.dart';

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
    final async = ref.watch(_workDetailProvider(workId));

    return async.when(
      loading: () => const SizedBox(
        height: 400,
        child: Center(
          child: CircularProgressIndicator(
            color: AppTheme.accentOrange,
            strokeWidth: 2,
          ),
        ),
      ),
      error: (e, _) => SizedBox(
        height: 400,
        child: Center(
          child: Text(
            '불러올 수 없습니다.',
            style: GoogleFonts.notoSansKr(fontSize: 14, color: AppTheme.textGray),
          ),
        ),
      ),
      data: (work) {
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
