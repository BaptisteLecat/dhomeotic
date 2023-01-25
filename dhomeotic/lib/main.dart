import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhomeotic/firebase_options.dart';
import 'package:dhomeotic/presentation/app/app.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  //Check if the user as authorized the app to send notifications.

  //create a doc test in the collection test
  await FirebaseFirestore.instance
      .collection('test')
      .doc('test')
      .set({'test': 'test'});
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await FirebaseMessaging.instance.getToken();
  log('FCM token: $fcmToken');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  BlocOverrides.runZoned(
    () => initializeDateFormatting('fr_FR', null)
        .then((_) => runApp(const AppRoot())),
    blocObserver: AppObserver(),
  );
}

class AppObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}
