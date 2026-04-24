// 작품 상세 페이지 상단의 '← WORKS' 뒤로 가기 버튼.
// 이전 페이지가 있으면 pop()으로 돌아가고, 없으면 WORKS 목록으로 이동합니다.
// (예: 새 탭에서 직접 열었을 때도 WORKS로 갈 수 있습니다)
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
  bool _hovered = false; // 마우스 호버 상태 (색상 변경용)

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {
          // 이전 히스토리가 있으면 뒤로, 없으면 WORKS 목록으로 이동
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
              // 호버 시 coral 색상으로 변경
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
