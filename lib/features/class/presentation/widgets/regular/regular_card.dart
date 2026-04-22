import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/bullet_list.dart';
import 'package:ourora/features/common/presentation/widgets/image_viewer_popup.dart';
import 'package:ourora/features/common/utils/responsive.dart';

class RegularCard extends StatefulWidget {
  final String title;
  final String description;
  final String? note;
  final TextStyle descriptionStyle;
  final List<String>? bullets;
  final Widget? image;
  final List<String>? curriculumImageUrls;
  final String? titleCaption;

  const RegularCard({
    super.key,
    required this.title,
    required this.description,
    required this.descriptionStyle,
    this.bullets,
    this.image,
    this.curriculumImageUrls,
    this.titleCaption,
    this.note,
  });

  @override
  State<RegularCard> createState() => _RegularCardState();
}

class _RegularCardState extends State<RegularCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return Column(
      children: [
        Padding(padding: const EdgeInsets.only(top: 16), child: Divider()),
        const SizedBox(height: 40),
        isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.titleCaption != null)
                    Text(
                      widget.titleCaption!,
                      style: GoogleFonts.notoSansKr(
                        fontSize: 15,
                        color: AppTheme.black,
                      ),
                    ),
                  Text(widget.title, style: AppTheme.pageTitle(isMobile)),
                  const SizedBox(height: 8),
                  if (widget.image != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: widget.image,
                    ),
                  Text(
                    '${widget.description}\n',
                    style: widget.descriptionStyle,
                  ),
                  if (widget.bullets != null)
                    BulletList(
                      items: widget.bullets!
                          .map((text) => TextSpan(text: text))
                          .toList(),
                      itemStyle: widget.descriptionStyle,
                    ),
                  if (widget.note != null)
                    Text('\n\n${widget.note!}', style: widget.descriptionStyle),
                  if (widget.curriculumImageUrls != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 20),
                      child: Center(
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) => setState(() => _hovered = true),
                          onExit: (_) => setState(() => _hovered = false),
                          child: OutlinedButton(
                            onPressed: () => ImageViewerPopup.show(
                              context,
                              imageUrls: widget.curriculumImageUrls!,
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppTheme.transparent),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(99),
                              ),
                              backgroundColor: _hovered
                                  ? AppTheme.coral
                                  : AppTheme.black,
                              foregroundColor: AppTheme.white,
                              surfaceTintColor: AppTheme.transparent,
                              overlayColor: AppTheme.transparent,
                            ),
                            child: SizedBox(
                              width: 200,
                              child: Center(
                                child: Text(
                                  '커리큘럼 자세히 보기',
                                  style: GoogleFonts.notoSansKr(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.titleCaption != null)
                          Text(
                            widget.titleCaption!,
                            style: GoogleFonts.notoSansKr(
                              fontSize: 15,
                              color: AppTheme.black,
                            ),
                          ),
                        Text(widget.title, style: AppTheme.pageTitle(isMobile)),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  const SizedBox(width: 108),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.image != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: widget.image,
                          ),
                        Text(
                          '${widget.description}\n\n',
                          style: widget.descriptionStyle,
                        ),
                        if (widget.bullets != null)
                          BulletList(
                            items: widget.bullets!
                                .map((text) => TextSpan(text: text))
                                .toList(),
                            itemStyle: widget.descriptionStyle,
                          ),
                        if (widget.note != null)
                          Text(
                            '\n\n${widget.note!}',
                            style: widget.descriptionStyle,
                          ),
                        if (widget.curriculumImageUrls != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 40, bottom: 20),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              onEnter: (_) => setState(() => _hovered = true),
                              onExit: (_) => setState(() => _hovered = false),
                              child: OutlinedButton(
                                onPressed: () => ImageViewerPopup.show(
                                  context,
                                  imageUrls: widget.curriculumImageUrls!,
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: AppTheme.transparent),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                  backgroundColor: _hovered
                                      ? AppTheme.coral
                                      : AppTheme.black,
                                  foregroundColor: AppTheme.white,
                                  surfaceTintColor: AppTheme.transparent,
                                  overlayColor: AppTheme.transparent,
                                ),
                                child: SizedBox(
                                  width: 200,
                                  child: Center(
                                    child: Text(
                                      '커리큘럼 자세히 보기',
                                      style: GoogleFonts.notoSansKr(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.white,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
