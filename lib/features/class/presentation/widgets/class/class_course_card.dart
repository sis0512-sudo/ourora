import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/responsive.dart';

class ClassCourseCard extends StatefulWidget {
  final String title;
  final String subTitle;
  final String description;
  final String assetPath;
  final bool showLogo;
  final VoidCallback? onTap;

  const ClassCourseCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.description,
    required this.assetPath,
    required this.onTap,
    this.showLogo = false,
  });

  @override
  State<ClassCourseCard> createState() => _ClassCourseCardState();
}

class _ClassCourseCardState extends State<ClassCourseCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return SizedBox(
      height: 500,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Image.asset(
            widget.assetPath,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          if (widget.showLogo)
            isMobile
                ? Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Image.asset(
                        'assets/images/ourora8_logo.png',
                        width: 385,
                        height: 108,
                      ),
                    ),
                  )
                : Positioned(
                    top: 16,
                    left: 16,
                    child: Image.asset(
                      'assets/images/ourora8_logo.png',
                      width: 385,
                      height: 108,
                    ),
                  ),
          isMobile
              ? Align(
                  alignment: widget.showLogo
                      ? Alignment.bottomCenter
                      : Alignment.topRight,
                  child: Container(
                    margin: widget.showLogo
                        ? EdgeInsets.all(32)
                        : EdgeInsets.only(top: 40, right: 32),
                    width: widget.showLogo ? null : 250,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'BMHanna',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.subTitle,
                          style: TextStyle(fontSize: 24, fontFamily: 'BMHanna'),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.description,
                          style: GoogleFonts.notoSansKr(fontSize: 14),
                        ),
                        const SizedBox(height: 20),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) => setState(() => _hovered = true),
                          onExit: (_) => setState(() => _hovered = false),
                          child: OutlinedButton(
                            onPressed: widget.onTap,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppTheme.transparent),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 19,
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
                              width: double.maxFinite,
                              child: Center(
                                child: Text(
                                  '자세히 알아보기',
                                  style: GoogleFonts.notoSansKr(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Positioned(
                  right: 60,
                  top: 40,
                  child: SizedBox(
                    width: 342,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'BMHanna',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.subTitle,
                          style: TextStyle(fontSize: 24, fontFamily: 'BMHanna'),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.description,
                          style: GoogleFonts.notoSansKr(fontSize: 14),
                        ),
                        const SizedBox(height: 20),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) => setState(() => _hovered = true),
                          onExit: (_) => setState(() => _hovered = false),
                          child: OutlinedButton(
                            onPressed: widget.onTap,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppTheme.transparent),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 19,
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
                              width: double.maxFinite,
                              child: Center(
                                child: Text(
                                  '자세히 알아보기',
                                  style: GoogleFonts.notoSansKr(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
