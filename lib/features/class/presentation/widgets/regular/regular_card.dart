import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/presentation/widgets/image_viewer_popup.dart';

class RegularCard extends StatefulWidget {
  final String title;
  final String description;
  final String? note;
  final TextStyle descriptionStyle;
  final List<String>? bullets;
  final Widget? image;
  final List<String>? curriculumImages;
  final String? titleCaption;

  const RegularCard({
    super.key,
    required this.title,
    required this.description,
    required this.descriptionStyle,
    this.bullets,
    this.image,
    this.curriculumImages,
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
    return Column(
      children: [
        Padding(padding: const EdgeInsets.only(top: 16), child: Divider()),
        const SizedBox(height: 40),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.titleCaption != null) Text(widget.titleCaption!, style: AppTheme.pageTitleCaption()),
                  Text(widget.title, style: AppTheme.pageTitle()),
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
                  if (widget.image != null) Padding(padding: const EdgeInsets.only(bottom: 16), child: widget.image),
                  Text('${widget.description}\n\n', style: widget.descriptionStyle),
                  if (widget.bullets != null)
                    ...widget.bullets!.mapIndexed((index, text) {
                      bool isLast = index == widget.bullets!.length - 1;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• ', style: widget.descriptionStyle.copyWith(fontWeight: FontWeight.bold)),
                          Expanded(
                            child: Text(text, style: widget.descriptionStyle.copyWith(fontWeight: isLast ? FontWeight.bold : FontWeight.normal)),
                          ),
                        ],
                      );
                    }),
                  if (widget.note != null) Text('\n\n${widget.note!}', style: widget.descriptionStyle),
                  if (widget.curriculumImages != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 20),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) => setState(() => _hovered = true),
                        onExit: (_) => setState(() => _hovered = false),
                        child: OutlinedButton(
                          onPressed: () => ImageViewerPopup.show(context, images: widget.curriculumImages!),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.transparent),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
                            backgroundColor: _hovered ? Color(0xFFFF6161) : AppTheme.black,
                            foregroundColor: AppTheme.white,
                            surfaceTintColor: Colors.transparent,
                            overlayColor: Colors.transparent,
                          ),
                          child: SizedBox(
                            width: 200,
                            child: Center(
                              child: Text(
                                '커리큘럼 자세히 보기',
                                style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.white, letterSpacing: 1),
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
