import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/domain/shared_pref_repository.dart';
import 'package:google_tasks/domain/task.repository.dart';
import 'package:google_tasks/feature/cubit/home_page_cubit.dart';
import 'package:google_tasks/feature/screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppDatabase database = AppDatabase();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  if (sharedPreferences.getInt("currentTab") == null) {
    List<TaskCategory> firstCategory =
        await database.select(database.taskCategories).get();
    sharedPreferences.setInt("currentTab", firstCategory[0].id);
  }

  Bloc.observer = SimpleBlocObserver();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  runApp(MyApp(
    db: database,
    sp: sharedPreferences,
  ));
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.db, required this.sp});

  final AppDatabase db;
  final SharedPreferences sp;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => TaskRepository(db: db),
        ),
        RepositoryProvider(
            create: (context) => SharedPreferencesRepository(sp: sp))
      ],
      child: BlocProvider(
        create: (context) => CurrentTabCubit(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Google Tasks Copy',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
