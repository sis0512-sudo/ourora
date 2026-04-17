import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ourora/features/common/presentation/screens/about_screen.dart';
import 'package:ourora/features/common/presentation/screens/class_screen.dart';
import 'package:ourora/features/common/presentation/screens/home_screen.dart';
import 'package:ourora/features/common/presentation/screens/membership_screen.dart';
import 'package:ourora/features/common/presentation/screens/works_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/works',
        builder: (context, state) => const WorksScreen(),
      ),
      GoRoute(
        path: '/class',
        builder: (context, state) => const ClassScreen(),
      ),
      GoRoute(
        path: '/membership',
        builder: (context, state) => const MembershipScreen(),
      ),
    ],
  );
});
