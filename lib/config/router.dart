import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ourora/features/common/presentation/screens/about_screen.dart';
import 'package:ourora/features/common/presentation/screens/class_screen.dart';
import 'package:ourora/features/common/presentation/screens/home_screen.dart';
import 'package:ourora/features/common/presentation/screens/contact_screen.dart';
import 'package:ourora/features/common/presentation/screens/membership_screen.dart';
import 'package:ourora/features/common/presentation/screens/works_screen.dart';

CustomTransitionPage<void> _noTransitionPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: Duration.zero,
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _noTransitionPage(state, const HomeScreen()),
      ),
      GoRoute(
        path: '/about',
        pageBuilder: (context, state) => _noTransitionPage(state, const AboutScreen()),
      ),
      GoRoute(
        path: '/works',
        pageBuilder: (context, state) => _noTransitionPage(state, const WorksScreen()),
      ),
      GoRoute(
        path: '/class',
        pageBuilder: (context, state) => _noTransitionPage(state, const ClassScreen()),
      ),
      GoRoute(
        path: '/membership',
        pageBuilder: (context, state) => _noTransitionPage(state, const MembershipScreen()),
      ),
      GoRoute(
        path: '/contact',
        pageBuilder: (context, state) => _noTransitionPage(state, const ContactScreen()),
      ),
    ],
  );
});
