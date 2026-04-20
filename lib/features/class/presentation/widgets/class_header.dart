import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/class/presentation/screens/class_screen.dart';
import 'package:ourora/features/common/presentation/widgets/title_widget.dart';

class ClassHeader extends StatefulWidget {
  final String title;
  final String description;
  final Widget image;

  const ClassHeader({super.key, required this.title, required this.description, required this.image});

  @override
  State<ClassHeader> createState() => _ClassHeaderState();
}

class _ClassHeaderState extends State<ClassHeader> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            child: GestureDetector(
              onTap: () => context.go(ClassScreen.route),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w400, color: _hovered ? AppTheme.red : AppTheme.textGray),
                child: Padding(padding: const EdgeInsets.all(8.0), child: Text('< CLASS 페이지로 돌아가기')),
              ),
            ),
          ),
        ),
        Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                TitleWidget(title: widget.title, isSubTitle: false),
                const SizedBox(height: 40),
                Text(widget.description, style: GoogleFonts.nanumMyeongjo(fontSize: 24, color: AppTheme.black)),
              ],
            ),
            Align(alignment: Alignment.topRight, child: widget.image),
          ],
        ),
      ],
    );
  }
}
