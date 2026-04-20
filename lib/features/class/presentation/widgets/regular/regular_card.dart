import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';

class RegularCard extends StatefulWidget {
  final String title;
  final String description;
  final String? note;
  final TextStyle descriptionStyle;
  final List<String>? bullets;
  final Widget? image;
  final String? titleCaption;

  const RegularCard({
    super.key,
    required this.title,
    required this.description,
    required this.descriptionStyle,
    this.bullets,
    this.image,
    this.titleCaption,
    this.note,
  });

  @override
  State<RegularCard> createState() => _RegularCardState();
}

class _RegularCardState extends State<RegularCard> {
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
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
