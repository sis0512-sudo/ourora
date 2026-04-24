// 앱의 전체 라우팅(페이지 이동) 설정 파일.
// go_router 패키지를 사용하며, 모든 페이지 경로(path)와 해당 화면(Widget)을 등록합니다.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ourora/features/about/presentation/screens/about_screen.dart';
import 'package:ourora/features/about/presentation/screens/fidp_screen.dart';
import 'package:ourora/features/class/presentation/screens/class_screen.dart';
import 'package:ourora/features/class/presentation/screens/ourora8_screen.dart';
import 'package:ourora/features/class/presentation/screens/regular_course_screen.dart';
import 'package:ourora/features/common/presentation/screens/home_screen.dart';
import 'package:ourora/features/common/utils/og_updater.dart';
import 'package:ourora/features/contact/presentation/screens/contact_screen.dart';
import 'package:ourora/features/membership/presentation/screens/membership_screen.dart';
import 'package:ourora/features/works/presentation/screens/work_post_screen.dart';
import 'package:ourora/features/works/presentation/screens/works_screen.dart';

// 페이지 전환 애니메이션 없이 즉시 이동하는 커스텀 페이지를 생성하는 헬퍼 함수.
// go_router의 pageBuilder에서 사용합니다.
CustomTransitionPage<void> _noTransitionPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: Duration.zero, // 전환 시간 0 → 즉시 전환
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child, // 애니메이션 없이 child 그대로 반환
  );
}

// GoRouter 인스턴스를 Riverpod Provider로 제공합니다.
// 앱 전체에서 ref.watch(routerProvider)로 라우터를 사용할 수 있습니다.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    redirect: (context, state) {
      // 모든 페이지 이동 시 OG 메타 태그(SNS 공유 미리보기)를 현재 경로에 맞게 업데이트합니다.
      updateOgMeta(state.uri.path);
      return null; // null을 반환하면 리다이렉트 없이 원래 경로로 이동
    },
    routes: [
      // ShellRoute: 모든 하위 라우트를 SelectionArea로 감쌉니다.
      // SelectionArea는 웹에서 텍스트 선택을 가능하게 합니다.
      ShellRoute(
        builder: (context, state, child) => SelectionArea(child: child),
        routes: [
          // 각 GoRoute: path(URL 경로) + pageBuilder(표시할 화면 위젯)
          GoRoute(path: HomeScreen.route, pageBuilder: (context, state) => _noTransitionPage(state, const HomeScreen())),
          GoRoute(path: AboutScreen.route, pageBuilder: (context, state) => _noTransitionPage(state, const AboutScreen())),
          GoRoute(path: FIDPScreen.route, pageBuilder: (context, state) => _noTransitionPage(state, const FIDPScreen())),
          GoRoute(path: WorksScreen.route, pageBuilder: (context, state) => _noTransitionPage(state, const WorksScreen())),
          GoRoute(
            // ':id'는 동적 경로 파라미터. 예: /post/abc123 → id = 'abc123'
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
