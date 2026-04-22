import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ourora/features/about/presentation/screens/about_screen.dart';
import 'package:ourora/features/about/presentation/screens/fidp_screen.dart';
import 'package:ourora/features/class/presentation/screens/class_screen.dart';
import 'package:ourora/features/class/presentation/screens/ourora8_screen.dart';
import 'package:ourora/features/class/presentation/screens/regular_course_screen.dart';
import 'package:ourora/features/common/presentation/screens/home_screen.dart';
import 'package:ourora/features/contact/presentation/screens/contact_screen.dart';
import 'package:ourora/features/membership/presentation/screens/membership_screen.dart';
import 'package:ourora/features/works/presentation/screens/work_post_screen.dart';
import 'package:ourora/features/works/presentation/screens/works_screen.dart';

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
      ShellRoute(
        builder: (context, state, child) => SelectionArea(child: child),
        routes: [
          GoRoute(path: HomeScreen.route, pageBuilder: (context, state) => _noTransitionPage(state, const HomeScreen())),
          GoRoute(path: AboutScreen.route, pageBuilder: (context, state) => _noTransitionPage(state, const AboutScreen())),
          GoRoute(path: FIDPScreen.route, pageBuilder: (context, state) => _noTransitionPage(state, const FIDPScreen())),
          GoRoute(path: WorksScreen.route, pageBuilder: (context, state) => _noTransitionPage(state, const WorksScreen())),
          GoRoute(
            path: WorkPostScreen.routePattern,
            pageBuilder: (context, state) => _noTransitionPage(state, WorkPostScreen(workId: state.pathParameters['id']!)),
          ),
          GoRoute(path: ClassScreen.route, pageBuilder: (context, state) => _noTransitionPage(state, const ClassScreen())),
          GoRoute(path: RegularCourseScreen.route, pageBuilder: (context, state) => _noTransitionPage(state, const RegularCourseScreen())),
          GoRoute(path: Ourora8Screen.route, pageBuilder: (context, state) => _noTransitionPage(state, const Ourora8Screen())),
          GoRoute(path: MembershipScreen.route, pageBuilder: (context, state) => _noTransitionPage(state, const MembershipScreen())),
          GoRoute(path: ContactScreen.route, pageBuilder: (context, state) => _noTransitionPage(state, const ContactScreen())),
        ],
      ),
    ],
  );
});
