import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ourora/config/theme.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  static const double height = 85;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      height: height,
      color: AppTheme.white,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => context.go('/'),
            child: Image.asset(
              'assets/images/logo.png',
              width: 169,
              height: 49,
              fit: BoxFit.contain,
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
      ('BOARD', '/board'),
      ('CONTACT', '/contact'),
    ];

    return Row(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(left: 28),
          child: GestureDetector(
            onTap: () => context.go(item.$2),
            child: Text(item.$1, style: AppTheme.navItem()),
          ),
        );
      }).toList(),
    );
  }
}

class _MobileMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu, color: AppTheme.black),
      onPressed: () {
        showModalBottomSheet(context: context, builder: (_) => const _MobileDrawer());
      },
    );
  }
}

class _MobileDrawer extends StatelessWidget {
  const _MobileDrawer();

  @override
  Widget build(BuildContext context) {
    const items = [
      ('ABOUT', '/about'),
      ('WORKS', '/works'),
      ('CLASS', '/class'),
      ('MEMBERSHIP', '/membership'),
      ('BOARD', '/board'),
      ('CONTACT', '/contact'),
    ];

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
