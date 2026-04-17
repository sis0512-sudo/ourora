import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/common/utils/responsive.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  static const double height = 85;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

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
          if (isMobile) _MobileMenu() else _DesktopMenu(),
        ],
      ),
    );
  }
}

class _DesktopMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const items = [
      ('ABOUT', '/about'),
      ('WORKS', '/works'),
      ('CLASS', '/class'),
      ('MEMBERSHIP', '/membership'),
      // ('BOARD', '/board'),
      ('CONTACT', '/contact'),
    ];

    return Row(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(left: 28),
          child: _NavItem(label: item.$1, route: item.$2),
        );
      }).toList(),
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
          style: AppTheme.navItem().copyWith(color: _hovered ? AppTheme.red : AppTheme.black),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

class _MobileMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: IconButton(
        icon: const Icon(Icons.menu, color: AppTheme.black),
        onPressed: () {
          showModalBottomSheet(context: context, builder: (_) => const _MobileDrawer());
        },
      ),
    );
  }
}

class _MobileDrawer extends StatelessWidget {
  const _MobileDrawer();

  @override
  Widget build(BuildContext context) {
    const items = [('ABOUT', '/about'), ('WORKS', '/works'), ('CLASS', '/class'), ('MEMBERSHIP', '/membership'), ('BOARD', '/board'), ('CONTACT', '/contact')];

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items.map((item) {
          return ListTile(
            title: Text(item.$1, style: AppTheme.navItem()),
            onTap: () {
              Navigator.pop(context);
              context.go(item.$2);
            },
          );
        }).toList(),
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
