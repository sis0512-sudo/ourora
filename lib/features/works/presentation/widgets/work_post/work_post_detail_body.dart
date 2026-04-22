import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/works/domain/work_item.dart';
import 'package:ourora/features/works/presentation/widgets/work_post/work_post_back_button.dart';
import 'package:ourora/features/works/presentation/widgets/work_post/work_post_image.dart';
import 'package:ourora/features/works/presentation/widgets/work_post/work_post_image_column.dart';
import 'package:ourora/features/works/presentation/widgets/work_post/work_post_youtube_embed.dart';

class WorkPostDetailBody extends StatelessWidget {
  final WorkItem work;

  const WorkPostDetailBody({super.key, required this.work});

  @override
  Widget build(BuildContext context) {
    final imageUrls = work.imageUrls;
    final hasImages = imageUrls.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.symmetric(vertical: 40), child: WorkPostBackButton()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                work.title,
                style: GoogleFonts.montserrat(fontSize: 40, fontWeight: FontWeight.w700, color: AppTheme.black, letterSpacing: 1),
              ),
              const SizedBox(height: 32),
              if (hasImages) ...[
                WorkPostImage(url: imageUrls.first),
                if (work.description.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(work.description, style: GoogleFonts.nanumGothic(fontSize: 18, color: AppTheme.textGray)),
                  const SizedBox(height: 16),
                ],
                const SizedBox(height: 16),
                WorkPostImageColumn(imageUrls: imageUrls.skip(1).toList()),
              ],
              if (!hasImages && work.description.isNotEmpty) ...[
                Text(work.description, style: GoogleFonts.nanumGothic(fontSize: 18, color: AppTheme.textGray)),
              ],
              if (work.youtubeUrl != null && work.youtubeUrl!.isNotEmpty) ...[const SizedBox(height: 48), WorkPostYoutubeEmbed(url: work.youtubeUrl!)],
              const SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }
}
