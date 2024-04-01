import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/domain/task.repository.dart';
import 'package:google_tasks/feature/task_bloc/task_bloc.dart';

import 'feature/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppDatabase database = AppDatabase();

  print(await database
      .select(database.taskCategories)
      .get()
      .then((value) => value));

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  runApp(MyApp(db: database));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.db});

  final AppDatabase db;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            TaskBloc(taskRepository: TaskRepository(db: db))
              ..add(const CategorySubscribeRequest()),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Google Tasks Copy',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          ),
          routerConfig: appRouter,
        ));
  }
}
