import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/features/common/presentation/widgets/bullet_list.dart';
import 'package:ourora/features/common/utils/responsive.dart';
import 'package:ourora/features/common/utils/utils.dart';

class FidpCard extends StatelessWidget {
  final String initial;
  final String title;
  final String description;
  final bool alignToLeft;
  final List<TextSpan>? bullets;

  const FidpCard({
    super.key,
    required this.initial,
    required this.title,
    required this.description,
    required this.alignToLeft,
    this.bullets,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;
    final double initialPadding = isMobile ? 0 : 85;
    final double margin = 16;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: isMobile
              ? [
                  if (alignToLeft)
                    Text(
                      initial,
                      style: const TextStyle(
                        fontFamily: 'ArialBlack',
                        fontSize: 110,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Align(
                        alignment: alignToLeft
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Text(
                          title,
                          style: GoogleFonts.notoSansKr(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!alignToLeft)
                    Text(
                      initial,
                      style: const TextStyle(
                        fontFamily: 'ArialBlack',
                        fontSize: 110,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                ]
              : [
                  SizedBox(
                    width: initialPadding,
                    child: alignToLeft
                        ? Text(
                            initial,
                            style: const TextStyle(
                              fontFamily: 'ArialBlack',
                              fontSize: 110,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  SizedBox(width: margin),
                  Expanded(
                    child: Align(
                      alignment: alignToLeft
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        title,
                        style: GoogleFonts.notoSansKr(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: margin),
                  SizedBox(
                    width: initialPadding,
                    child: alignToLeft
                        ? const SizedBox.shrink()
                        : Text(
                            initial,
                            style: const TextStyle(
                              fontFamily: 'ArialBlack',
                              fontSize: 110,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                  ),
                ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: initialPadding + margin),
          child: Column(
            children: [
              Text(
                Utils.formatText(description),
                style: GoogleFonts.notoSansKr(fontSize: isMobile ? 20 : 18),
              ),
              if (bullets != null) BulletList(items: bullets!),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
