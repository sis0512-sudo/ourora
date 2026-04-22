import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/works/presentation/screens/works_screen.dart';

class WorkPostBackButton extends StatefulWidget {
  const WorkPostBackButton({super.key});

  @override
  State<WorkPostBackButton> createState() => _WorkPostBackButtonState();
}

class _WorkPostBackButtonState extends State<WorkPostBackButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(WorksScreen.route);
          }
        },
        child: SelectionContainer.disabled(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back, size: 16, color: _hovered ? AppTheme.coral : AppTheme.textGray),
              const SizedBox(width: 8),
              Text(
                'WORKS',
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _hovered ? AppTheme.coral : AppTheme.textGray,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
