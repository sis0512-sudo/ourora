// 모든 페이지 상단에 고정(pinned)되는 네비게이션 바.
// 데스크톱: 로고 + 가로 메뉴, 모바일: 로고 + 햄버거 버튼(슬라이드 드로어)
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/about/presentation/screens/about_screen.dart';
import 'package:ourora/features/class/presentation/screens/class_screen.dart';
import 'package:ourora/features/class/presentation/screens/ourora8_screen.dart';
import 'package:ourora/features/class/presentation/screens/regular_course_screen.dart';
import 'package:ourora/features/common/utils/constants.dart';
import 'package:ourora/features/common/utils/responsive.dart';
import 'package:ourora/features/contact/presentation/screens/contact_screen.dart';
import 'package:ourora/features/membership/presentation/screens/membership_screen.dart';
import 'package:ourora/features/works/presentation/screens/works_screen.dart';
import 'package:web/web.dart' as web;

// 네비게이션 바 위젯. 높이 상수와 실제 Widget을 함께 관리합니다.
class NavBar extends StatefulWidget {
  const NavBar({super.key});

  static const double mobileHeight = 100;
  static const double desktopHeight = 85;
  // 현재 기기에 맞는 높이를 반환합니다.
  static double get height => Responsive.isMobileDevice ? mobileHeight : desktopHeight;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  OverlayEntry? _drawerEntry; // 현재 열려 있는 모바일 드로어의 Overlay 항목

  // iframe(지도, 영상 등)의 포인터 이벤트를 활성화/비활성화합니다.
  // 드로어가 열려있을 때 iframe 위에서 마우스 이벤트가 드로어를 통과하는 문제를 방지합니다.
  void _setIframesPointerEvents(String value) {
    final iframes = web.document.querySelectorAll('iframe');
    for (int i = 0; i < iframes.length; i++) {
      final iframe = iframes.item(i) as web.HTMLElement?;
      iframe?.style.pointerEvents = value;
    }
  }

  // 모바일 드로어를 화면에 표시합니다. (Overlay를 사용하여 다른 위젯 위에 렌더링)
  void _openDrawer() {
    if (_drawerEntry != null) return; // 이미 열려있으면 중복 실행 방지
    _setIframesPointerEvents('none'); // iframe 포인터 이벤트 비활성화
    _drawerEntry = OverlayEntry(builder: (_) => _MobileDrawer(onClose: _closeDrawer));
    Overlay.of(context).insert(_drawerEntry!);
  }

  // 모바일 드로어를 닫습니다.
  void _closeDrawer() {
    _drawerEntry?.remove();
    _drawerEntry = null;
    _setIframesPointerEvents('auto'); // iframe 포인터 이벤트 다시 활성화
  }

  @override
  void dispose() {
    _closeDrawer(); // 위젯 소멸 시 드로어 정리
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return Container(
      height: NavBar.height,
      color: AppTheme.white,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: AppConstants.windowMaxWidth),
          child: isMobile
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 가운데 로고 (탭 시 홈으로 이동)
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => context.go('/'),
                          child: Image.asset('assets/images/logo.png', width: 220, fit: BoxFit.contain),
                        ),
                      ),
                      // 오른쪽 햄버거 메뉴 버튼
                      Align(
                        alignment: Alignment.centerRight,
                        child: _HamburgerButton(onTap: _openDrawer),
                      ),
                    ],
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 왼쪽 로고
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => context.go('/'),
                        child: Image.asset('assets/images/logo.png', width: 169, height: 49, fit: BoxFit.contain),
                      ),
                    ),
                    // 오른쪽 메뉴 항목들
                    const _DesktopMenu(),
                  ],
                ),
        ),
      ),
    );
  }
}

// 모바일 햄버거(≡) 버튼
class _HamburgerButton extends StatelessWidget {
  const _HamburgerButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: const Icon(Icons.menu, size: 28, color: AppTheme.black),
      ),
    );
  }
}

// 모바일에서 오른쪽에서 슬라이드로 들어오는 드로어(서랍) 메뉴.
// SingleTickerProviderStateMixin: AnimationController에 필요한 vsync를 제공합니다.
class _MobileDrawer extends StatefulWidget {
  const _MobileDrawer({required this.onClose});

  final VoidCallback onClose;

  @override
  State<_MobileDrawer> createState() => _MobileDrawerState();
}

class _MobileDrawerState extends State<_MobileDrawer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnim;
  bool _classExpanded = false; // CLASS 하위 메뉴 펼침 상태

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));
    // 오른쪽 밖(Offset(1,0))에서 화면 안(Offset.zero)으로 슬라이드 인
    _slideAnim = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward(); // 열기 애니메이션 시작
  }

  // 닫기 애니메이션 후 드로어를 제거합니다.
  Future<void> _close() async {
    await _controller.reverse(); // 역방향(닫기) 애니메이션
    widget.onClose();
  }

  // 메뉴 항목 탭 시: 드로어를 닫고 해당 라우트로 이동합니다.
  Future<void> _goTo(String route) async {
    final router = GoRouter.of(context);
    await _close();
    router.go(route);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.transparent,
      child: Stack(
        children: [
          // 어두운 반투명 배경: 탭 시 드로어 닫기
          GestureDetector(
            onTap: _close,
            child: Container(color: AppTheme.black.withValues(alpha: 0.4)),
          ),
          // 오른쪽에서 슬라이드로 나타나는 드로어 패널
          Align(
            alignment: Alignment.centerRight,
            child: SlideTransition(
              position: _slideAnim,
              child: Container(
                width: 280,
                height: double.infinity,
                color: AppTheme.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 우상단 X 닫기 버튼
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: _close,
                            child: const Icon(Icons.close, size: 24, color: AppTheme.white),
                          ),
                        ),
                      ),
                    ),
                    _DrawerItem(label: 'ABOUT', onTap: () => _goTo(AboutScreen.route)),
                    _DrawerItem(label: 'WORKS', onTap: () => _goTo(WorksScreen.route)),
                    // CLASS: 탭하면 페이지 이동, 화살표 탭하면 하위 메뉴 토글
                    _DrawerItem(
                      label: 'CLASS',
                      trailing: Icon(_classExpanded ? Icons.expand_less : Icons.expand_more, size: 20, color: AppTheme.white),
                      onTap: () => _goTo(ClassScreen.route),
                      onTrailingTap: () => setState(() => _classExpanded = !_classExpanded),
                    ),
                    // CLASS 하위 메뉴 (펼쳐졌을 때만 표시)
                    if (_classExpanded) ...[
                      _DrawerSubItem(label: 'REGULAR COURSE', onTap: () => _goTo(RegularCourseScreen.route)),
                      _DrawerSubItem(label: 'OURORA 8', onTap: () => _goTo(Ourora8Screen.route)),
                    ],
                    _DrawerItem(label: 'MEMBERSHIP', onTap: () => _goTo(MembershipScreen.route)),
                    _DrawerItem(label: 'CONTACT', onTap: () => _goTo(ContactScreen.route)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 드로어의 메인 메뉴 항목 (호버 효과 포함)
class _DrawerItem extends StatefulWidget {
  const _DrawerItem({required this.label, required this.onTap, this.trailing, this.onTrailingTap});

  final String label;
  final VoidCallback onTap;
  final Widget? trailing;        // 오른쪽에 표시할 추가 위젯 (화살표 아이콘 등)
  final VoidCallback? onTrailingTap; // trailing 위젯 탭 이벤트

  @override
  State<_DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<_DrawerItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          color: isMobile
              ? AppTheme.black
              : _hovered
              ? AppTheme.lightGray
              : AppTheme.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // SelectionContainer.disabled: 텍스트 선택 드래그가 메뉴 탭과 충돌하지 않도록 비활성화
              SelectionContainer.disabled(
                child: Text(
                  widget.label,
                  style: AppTheme.navItem(isMobile).copyWith(fontSize: isMobile ? 24 : 14, color: isMobile ? AppTheme.white : AppTheme.textGray),
                ),
              ),
              // trailing이 있고 별도 탭 이벤트가 있으면 GestureDetector로 감쌉니다.
              if (widget.trailing != null)
                widget.onTrailingTap != null
                    ? GestureDetector(
                        onTap: () {
                          widget.onTrailingTap!();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: widget.trailing!,
                      )
                    : widget.trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

// 드로어의 서브 메뉴 항목 (들여쓰기 적용)
class _DrawerSubItem extends StatefulWidget {
  const _DrawerSubItem({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_DrawerSubItem> createState() => _DrawerSubItemState();
}

class _DrawerSubItemState extends State<_DrawerSubItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 44, right: 28, top: 13, bottom: 13), // 왼쪽 들여쓰기
          color: isMobile
              ? AppTheme.black
              : _hovered
              ? AppTheme.borderGray
              : AppTheme.lightGray,
          child: SelectionContainer.disabled(
            child: Text(
              widget.label,
              style: AppTheme.navItem(isMobile).copyWith(fontSize: isMobile ? 18 : 12, color: isMobile ? AppTheme.white : AppTheme.textGray),
            ),
          ),
        ),
      ),
    );
  }
}

// 데스크톱 네비게이션 메뉴 (ABOUT / WORKS / CLASS / MEMBERSHIP / CONTACT)
class _DesktopMenu extends StatelessWidget {
  const _DesktopMenu();

  @override
  Widget build(BuildContext context) {
    const items = [('ABOUT', AboutScreen.route), ('WORKS', WorksScreen.route)];
    const trailingItems = [('MEMBERSHIP', MembershipScreen.route), ('CONTACT', ContactScreen.route)];

    return Row(
      children: [
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: 28),
            child: _NavItem(label: item.$1, route: item.$2),
          ),
        ),
        // CLASS: 호버 시 드롭다운 서브메뉴가 나타나는 특별 메뉴 아이템
        const Padding(padding: EdgeInsets.only(left: 28), child: _ClassNavItem()),
        ...trailingItems.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: 28),
            child: _NavItem(label: item.$1, route: item.$2),
          ),
        ),
      ],
    );
  }
}

// 일반 네비게이션 메뉴 아이템 (호버 시 빨간색으로 변경)
class _NavItem extends StatefulWidget {
  const _NavItem({required this.label, required this.route});

  final String label;
  final String route;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go(widget.route),
        // AnimatedDefaultTextStyle: 색상 변경을 부드럽게 애니메이션 처리
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: AppTheme.navItem(isMobile).copyWith(color: _hovered ? AppTheme.red : AppTheme.textGray),
          child: SelectionContainer.disabled(child: Text(widget.label)),
        ),
      ),
    );
  }
}

// CLASS 메뉴 아이템: 호버 시 드롭다운 서브메뉴(REGULAR COURSE / OURORA 8)가 표시됩니다.
// CompositedTransformTarget/Follower로 드롭다운의 위치를 버튼 아래에 정확히 고정합니다.
class _ClassNavItem extends StatefulWidget {
  const _ClassNavItem();

  @override
  State<_ClassNavItem> createState() => _ClassNavItemState();
}

class _ClassNavItemState extends State<_ClassNavItem> {
  bool _hovered = false;
  OverlayEntry? _overlayEntry; // 드롭다운 메뉴의 Overlay 항목
  final _layerLink = LayerLink(); // 드롭다운 위치를 버튼에 연결하는 링크
  Timer? _closeTimer;            // 마우스가 드롭다운을 벗어났을 때 약간의 딜레이 후 닫기

  // 닫기 타이머를 취소합니다 (드롭다운으로 마우스가 이동했을 때 호출)
  void _cancelClose() {
    _closeTimer?.cancel();
    _closeTimer = null;
  }

  // 150ms 후 드롭다운을 닫는 타이머를 시작합니다.
  void _scheduleClose() {
    _cancelClose();
    _closeTimer = Timer(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => _hovered = false);
      _removeDropdown();
    });
  }

  // 드롭다운 메뉴를 Overlay에 추가합니다.
  void _showDropdown() {
    _cancelClose();
    if (_overlayEntry != null) return; // 이미 열려있으면 중복 실행 방지
    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);
  }

  // 드롭다운 메뉴를 제거합니다.
  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // 드롭다운 메뉴 Overlay 항목을 생성합니다.
  // CompositedTransformFollower: layerLink로 연결된 버튼 아래에 위치를 자동으로 맞춥니다.
  OverlayEntry _buildOverlay() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: 180,
        child: CompositedTransformFollower(
          link: _layerLink,
          targetAnchor: Alignment.bottomLeft, // 버튼의 좌하단을
          followerAnchor: Alignment.topLeft,  // 드롭다운의 좌상단에 맞춥니다.
          offset: const Offset(0, 8),
          child: MouseRegion(
            onEnter: (_) => _cancelClose(), // 드롭다운으로 마우스 진입 시 닫기 취소
            onExit: (_) => _scheduleClose(),
            child: Material(elevation: 4, child: _ClassDropdownMenu(onClose: _removeDropdown)),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cancelClose();
    _removeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return CompositedTransformTarget(
      link: _layerLink, // 드롭다운의 기준 위치로 사용
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() => _hovered = true);
          _showDropdown(); // 마우스 진입 시 드롭다운 표시
        },
        onExit: (_) => _scheduleClose(), // 마우스 이탈 시 닫기 예약
        child: GestureDetector(
          onTap: () => context.go(ClassScreen.route), // 클릭 시 CLASS 페이지로 이동
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: AppTheme.navItem(isMobile).copyWith(color: _hovered ? AppTheme.red : AppTheme.textGray),
            child: const SelectionContainer.disabled(child: Text('CLASS')),
          ),
        ),
      ),
    );
  }
}

// CLASS 드롭다운 메뉴 (REGULAR COURSE / OURORA 8)
class _ClassDropdownMenu extends StatelessWidget {
  const _ClassDropdownMenu({required this.onClose});

  final VoidCallback onClose; // 메뉴 항목 선택 시 드롭다운을 닫기 위한 콜백

  @override
  Widget build(BuildContext context) {
    final items = [('REGULAR COURSE', RegularCourseScreen.route), ('OURORA 8', Ourora8Screen.route)];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: items.map((item) {
        return _DropdownItem(label: item.$1, route: item.$2, onClose: onClose);
      }).toList(),
    );
  }
}

// 드롭다운의 각 메뉴 항목
class _DropdownItem extends StatefulWidget {
  const _DropdownItem({required this.label, required this.route, required this.onClose});

  final String label;
  final String route;
  final VoidCallback onClose;

  @override
  State<_DropdownItem> createState() => _DropdownItemState();
}

class _DropdownItemState extends State<_DropdownItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileDevice;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {
          widget.onClose(); // 드롭다운 닫기
          context.go(widget.route); // 해당 페이지로 이동
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          color: _hovered ? AppTheme.lightGray : AppTheme.white,
          child: SelectionContainer.disabled(child: Text(widget.label, style: AppTheme.navItem(isMobile).copyWith(fontSize: 12))),
        ),
      ),
    );
  }
}

// SliverPersistentHeader와 함께 사용하는 NavBar 델리게이트.
// pinned: true로 설정하면 스크롤해도 상단에 고정됩니다.
class NavBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => NavBar.height; // 최소 높이 = 최대 높이 = 고정 높이

  @override
  double get maxExtent => NavBar.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return const NavBar();
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
