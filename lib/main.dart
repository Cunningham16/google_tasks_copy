import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/data/entities/category.entity.dart';
import 'package:google_tasks/domain/task.repository.dart';
import 'package:google_tasks/feature/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppDatabase database = AppDatabase();

  Bloc.observer = SimpleBlocObserver();

  //database.select(database.taskCategories).watch().listen((event) {
  //  print(event);
  //});

  await database.deleteTable();

  await database.into(database.taskCategories).insert(
      const CategoryEntity(name: "Избранное", isDeleteable: false)
          .toCompanion());
  await database.into(database.taskCategories).insert(
      const CategoryEntity(name: "Мои задачи", isDeleteable: false)
          .toCompanion());

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  runApp(MyApp(db: database));
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.db});

  final AppDatabase db;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      lazy: true,
      create: (context) => TaskRepository(db: db),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Google Tasks Copy',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
