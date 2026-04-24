// 앱 실행 전 필요한 초기화 작업들을 순서대로 수행하는 함수.
// main()에서 호출되며, 완료 후 runApp()으로 Flutter 위젯 트리를 시작합니다.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourora/features/contact/presentation/widgets/contact_map_view.dart';
import 'package:ourora/firebase_options.dart';
import 'package:url_strategy/url_strategy.dart';

// [builder]는 루트 Widget을 반환하는 함수입니다.
// Future<void>를 반환하므로 async/await 사용이 가능합니다.
Future<void> bootstrap(Widget Function() builder) async {
  // Flutter 엔진과 위젯 바인딩이 완료될 때까지 기다립니다. (비동기 초기화 전 필수 호출)
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 프로젝트에 연결합니다. DefaultFirebaseOptions는 자동 생성된 firebase_options.dart에서 가져옵니다.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Firestore 오프라인 캐시를 활성화합니다. 네트워크 없이도 이전 데이터를 볼 수 있습니다.
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);

  // URL에서 '#' 해시를 제거합니다. 예: '/works#/about' → '/about' 형태 대신 '/about' 직접 사용
  setPathUrlStrategy();

  // Google Maps iframe 뷰를 Flutter Web에서 사용할 수 있도록 사전 등록합니다.
  registerContactMapView();

  // ProviderScope으로 전체 앱을 감싸야 Riverpod의 상태관리가 작동합니다.
  runApp(ProviderScope(child: builder()));
}
