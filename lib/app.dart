import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourora/config/router.dart';
import 'package:ourora/config/theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: '가구공방 오로라스튜디오 | OURORA STUDIO',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      routerConfig: router,
    );
  }
}
