// 앱의 최상위 Widget. MaterialApp.router를 생성하고 라우터·테마를 연결합니다.
// ConsumerWidget을 상속하여 Riverpod으로 routerProvider를 구독합니다.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourora/config/router.dart';
import 'package:ourora/config/theme.dart';

// ConsumerWidget: Riverpod의 ref.watch()를 사용할 수 있는 StatelessWidget
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // routerProvider를 구독하여 GoRouter 인스턴스를 가져옵니다.
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: '가구공방 오로라스튜디오 | OURORA STUDIO',
      debugShowCheckedModeBanner: false, // 오른쪽 상단 'DEBUG' 배너 숨기기
      theme: AppTheme.themeData, // 앱 전체 색상·폰트 테마 적용
      routerConfig: router, // go_router 설정을 MaterialApp에 연결
    );
  }
}
