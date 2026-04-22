import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/responsive.dart';
import 'package:ourora/features/common/utils/utils.dart';
import 'package:ourora/features/works/domain/work_item.dart';
import 'package:ourora/features/works/presentation/widgets/work_post/work_post_back_button.dart';
import 'package:ourora/features/works/presentation/widgets/work_post/work_post_image.dart';
import 'package:ourora/features/works/presentation/widgets/work_post/work_post_image_column.dart';
import 'package:ourora/features/works/presentation/widgets/work_post/work_post_youtube_embed.dart';

enum ShareType { facebook, x, linkedin, copy }

extension ShareTypeX on ShareType {
  String get svgAsset {
    switch (this) {
      case ShareType.facebook:
        return 'assets/svgs/facebook.svg';
      case ShareType.x:
        return 'assets/svgs/twitter.svg';
      case ShareType.linkedin:
        return 'assets/svgs/linkedin.svg';
      case ShareType.copy:
        return 'assets/svgs/link.svg';
    }
  }
}

class WorkPostDetailBody extends StatelessWidget {
  final WorkItem work;

  const WorkPostDetailBody({super.key, required this.work});

  @override
  Widget build(BuildContext context) {
    String currentUrl = html.window.location.href;
    final imageUrls = work.imageUrls;
    final isMobile = Responsive.isMobileDevice;
    final hasImages = imageUrls.isNotEmpty;

    return Padding(
      padding: isMobile ? EdgeInsets.symmetric(horizontal: 32) : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.symmetric(vertical: 40), child: WorkPostBackButton()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  work.title,
                  style: GoogleFonts.montserrat(fontSize: 40, fontWeight: FontWeight.w700, color: AppTheme.black, letterSpacing: 1),
                ),
                const SizedBox(height: 32),
                if (hasImages) ...[
                  WorkPostImage(imageUrl: imageUrls.first),
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
                Padding(padding: const EdgeInsets.symmetric(vertical: 40), child: Divider()),
                Row(
                  children: ShareType.values.map((e) => _ShareButton(type: e, onTap: () => Utils.shareUrl(currentUrl, e))).toList(),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareButton extends StatefulWidget {
  final ShareType type;
  final VoidCallback onTap;

  const _ShareButton({required this.type, required this.onTap});

  @override
  State<_ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<_ShareButton> {
  bool _hovered = false;
  bool _showCopied = false;

  void _handleTap() {
    widget.onTap();
    if (widget.type == ShareType.copy) {
      setState(() => _showCopied = true);
      Future.delayed(const Duration(milliseconds: 1800), () {
        if (mounted) setState(() => _showCopied = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _handleTap,
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                widget.type.svgAsset,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(_hovered ? AppTheme.coral : AppTheme.black, BlendMode.srcIn),
              ),
            ),
            if (widget.type == ShareType.copy)
              Positioned(
                bottom: 52,
                child: AnimatedOpacity(
                  opacity: _showCopied ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: AppTheme.black, borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      '링크 복사 완료',
                      style: TextStyle(color: AppTheme.white, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
