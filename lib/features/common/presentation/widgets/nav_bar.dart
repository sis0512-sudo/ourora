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

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  static const double mobileHeight = 100;
  static const double desktopHeight = 85;
  static double get height => Responsive.isMobileDevice ? mobileHeight : desktopHeight;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  OverlayEntry? _drawerEntry;

  void _setIframesPointerEvents(String value) {
    final iframes = web.document.querySelectorAll('iframe');
    for (int i = 0; i < iframes.length; i++) {
      final iframe = iframes.item(i) as web.HTMLElement?;
      iframe?.style.pointerEvents = value;
    }
  }

  void _openDrawer() {
    if (_drawerEntry != null) return;
    _setIframesPointerEvents('none');
    _drawerEntry = OverlayEntry(builder: (_) => _MobileDrawer(onClose: _closeDrawer));
    Overlay.of(context).insert(_drawerEntry!);
  }

  void _closeDrawer() {
    _drawerEntry?.remove();
    _drawerEntry = null;
    _setIframesPointerEvents('auto');
  }

  @override
  void dispose() {
    _closeDrawer();
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
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => context.go('/'),
                          child: Image.asset('assets/images/logo.png', width: 220, fit: BoxFit.contain),
                        ),
                      ),
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
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => context.go('/'),
                        child: Image.asset('assets/images/logo.png', width: 169, height: 49, fit: BoxFit.contain),
                      ),
                    ),
                    const _DesktopMenu(),
                  ],
                ),
        ),
      ),
    );
  }
}

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

class _MobileDrawer extends StatefulWidget {
  const _MobileDrawer({required this.onClose});

  final VoidCallback onClose;

  @override
  State<_MobileDrawer> createState() => _MobileDrawerState();
}

class _MobileDrawerState extends State<_MobileDrawer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnim;
  bool _classExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));
    _slideAnim = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  Future<void> _close() async {
    await _controller.reverse();
    widget.onClose();
  }

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
          GestureDetector(
            onTap: _close,
            child: Container(color: AppTheme.black.withValues(alpha: 0.4)),
          ),
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
                    _DrawerItem(
                      label: 'CLASS',
                      trailing: Icon(_classExpanded ? Icons.expand_less : Icons.expand_more, size: 20, color: AppTheme.white),
                      onTap: () => _goTo(ClassScreen.route),
                      onTrailingTap: () => setState(() => _classExpanded = !_classExpanded),
                    ),
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

class _DrawerItem extends StatefulWidget {
  const _DrawerItem({required this.label, required this.onTap, this.trailing, this.onTrailingTap});

  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
  final VoidCallback? onTrailingTap;

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
              SelectionContainer.disabled(
                child: Text(
                  widget.label,
                  style: AppTheme.navItem(isMobile).copyWith(fontSize: isMobile ? 24 : 14, color: isMobile ? AppTheme.white : AppTheme.textGray),
                ),
              ),
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
          padding: const EdgeInsets.only(left: 44, right: 28, top: 13, bottom: 13),
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
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: AppTheme.navItem(isMobile).copyWith(color: _hovered ? AppTheme.red : AppTheme.textGray),
          child: SelectionContainer.disabled(child: Text(widget.label)),
        ),
      ),
    );
  }
}

class _ClassNavItem extends StatefulWidget {
  const _ClassNavItem();

  @override
  State<_ClassNavItem> createState() => _ClassNavItemState();
}

class _ClassNavItemState extends State<_ClassNavItem> {
  bool _hovered = false;
  OverlayEntry? _overlayEntry;
  final _layerLink = LayerLink();
  Timer? _closeTimer;

  void _cancelClose() {
    _closeTimer?.cancel();
    _closeTimer = null;
  }

  void _scheduleClose() {
    _cancelClose();
    _closeTimer = Timer(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => _hovered = false);
      _removeDropdown();
    });
  }

  void _showDropdown() {
    _cancelClose();
    if (_overlayEntry != null) return;
    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _buildOverlay() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: 180,
        child: CompositedTransformFollower(
          link: _layerLink,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, 8),
          child: MouseRegion(
            onEnter: (_) => _cancelClose(),
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
      link: _layerLink,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() => _hovered = true);
          _showDropdown();
        },
        onExit: (_) => _scheduleClose(),
        child: GestureDetector(
          onTap: () => context.go(ClassScreen.route),
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

class _ClassDropdownMenu extends StatelessWidget {
  const _ClassDropdownMenu({required this.onClose});

  final VoidCallback onClose;

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
          widget.onClose();
          context.go(widget.route);
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

class NavBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => NavBar.height;

  @override
  double get maxExtent => NavBar.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return const NavBar();
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
