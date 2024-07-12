import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/domain/repositories/shared_pref_repository.dart';
import 'package:google_tasks/firebase_options.dart';
import 'package:google_tasks/presentation/router/router.dart';
import 'package:google_tasks/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initServiceLocator();
  await serviceLocator.allReady();

  if (serviceLocator<SharedPreferencesRepository>().getLastTab() == null) {
    serviceLocator<SharedPreferencesRepository>().setLastTab(0);
  }

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  FirebaseAuth.instance.authStateChanges().listen((event) {
    router.refresh();
  });

  SimpleBlocObserver();

  runApp(const AppView());
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Google Tasks Copy',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0099cc)),
      ),
      routerConfig: router,
    );
  }
}
