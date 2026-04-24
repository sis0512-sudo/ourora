import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ourora/features/contact/presentation/widgets/contact_map_view.dart';
import 'package:ourora/firebase_options.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> bootstrap(Widget Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);

  setPathUrlStrategy();
  registerContactMapView();

  runApp(ProviderScope(child: builder()));
}
