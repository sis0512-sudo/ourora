import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';

class ClassCourseCard extends StatefulWidget {
  final String title;
  final String subTitle;
  final String description;
  final String imagePath;
  final bool showLogo;
  final VoidCallback? onTap;

  const ClassCourseCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.description,
    required this.imagePath,
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
    return SizedBox(
      height: 500,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Image.asset(widget.imagePath, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
          if (widget.showLogo) Positioned(top: 16, left: 16, child: Image.asset('assets/images/ourora8_logo.webp', width: 385, height: 108)),
          Positioned(
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
                    style: TextStyle(fontSize: 30, fontFamily: 'BMHanna', fontWeight: FontWeight.bold),
                  ),
                  Text(widget.subTitle, style: TextStyle(fontSize: 24, fontFamily: 'BMHanna')),
                  const SizedBox(height: 12),
                  Text(widget.description, style: GoogleFonts.openSans(fontSize: 14)),
                  const SizedBox(height: 20),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => _hovered = true),
                    onExit: (_) => setState(() => _hovered = false),
                    child: OutlinedButton(
                      onPressed: widget.onTap,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.transparent),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 19),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
                        backgroundColor: _hovered ? Color(0xFFFF6161) : AppTheme.black,
                        foregroundColor: AppTheme.white,
                        surfaceTintColor: Colors.transparent,
                        overlayColor: Colors.transparent,
                      ),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Center(
                          child: Text(
                            '자세히 알아보기',
                            style: GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.white, letterSpacing: 1),
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
