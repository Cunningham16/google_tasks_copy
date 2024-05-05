import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/domain/shared_pref_repository.dart';
import 'package:google_tasks/domain/task_repository.dart';
import 'package:google_tasks/feature/category_bloc/category_bloc.dart';
import 'package:google_tasks/feature/task_bloc/tasks_bloc.dart';
import 'package:google_tasks/feature/cubit/home_page_cubit.dart';
import 'package:google_tasks/feature/screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppDatabase database = AppDatabase();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  CurrentTabCubit currentTabCubit = CurrentTabCubit();

  if (sharedPreferences.getInt("currentTab") == null) {
    List<TaskCategory> firstCategory =
        await database.select(database.taskCategories).get();
    sharedPreferences.setInt("currentTab", firstCategory[0].id);
    currentTabCubit.changeTab(firstCategory[0].id);
  } else {
    currentTabCubit.changeTab(sharedPreferences.getInt("currentTab")!);
  }

  //Bloc.observer = SimpleBlocObserver();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  runApp(MyApp(
    cubit: currentTabCubit,
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
  const MyApp(
      {super.key, required this.db, required this.sp, required this.cubit});

  final AppDatabase db;
  final SharedPreferences sp;
  final CurrentTabCubit cubit;

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
      child: Builder(builder: (context) {
        TaskRepository taskRepo =
            RepositoryProvider.of<TaskRepository>(context);

        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => cubit),
            BlocProvider(
                create: (context) => TaskBloc(taskRepository: taskRepo)
                  ..add(const TaskSubscribtionRequested())),
            BlocProvider(
                create: (_) => CategoryBloc(taskRepository: taskRepo)
                  ..add(const CategorySubscriptionRequested()))
          ],
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
      }),
    );
  }
}
