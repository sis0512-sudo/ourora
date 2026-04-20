import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/about/presentation/screens/about_screen.dart';
import 'package:ourora/features/class/presentation/screens/class_screen.dart';
import 'package:ourora/features/class/presentation/screens/ourora8_screen.dart';
import 'package:ourora/features/class/presentation/screens/regular_course_screen.dart';
import 'package:ourora/features/contact/presentation/screens/contact_screen.dart';
import 'package:ourora/features/membership/presentation/screens/membership_screen.dart';
import 'package:ourora/features/works/presentation/screens/works_screen.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  static const double height = 85;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: AppTheme.white,
      padding: const EdgeInsets.symmetric(horizontal: 110),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => context.go('/'),
              child: Image.asset('assets/images/logo.png', width: 169, height: 49, fit: BoxFit.contain),
            ),
          ),
          _DesktopMenu(),
        ],
      ),
    );
  }
}

class _DesktopMenu extends StatelessWidget {
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go(widget.route),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: AppTheme.navItem().copyWith(color: _hovered ? AppTheme.red : AppTheme.textGray),
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
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() => _hovered = true);
          _showDropdown();
        },
        onExit: (_) {
          _scheduleClose();
        },
        child: GestureDetector(
          onTap: () => context.go(ClassScreen.route),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: AppTheme.navItem().copyWith(color: _hovered ? AppTheme.red : AppTheme.textGray),
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
          child: SelectionContainer.disabled(child: Text(widget.label, style: AppTheme.navItem().copyWith(fontSize: 12))),
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
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
