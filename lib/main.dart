import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/data/repositories/auth_repository_impl.dart';
import 'package:google_tasks/data/repositories/category_repository_impl.dart';
import 'package:google_tasks/data/repositories/shared_pref_repository_impl.dart';
import 'package:google_tasks/data/repositories/task_repository_impl.dart';
import 'package:google_tasks/domain/repositories/task_repository.dart';
import 'package:google_tasks/firebase_options.dart';
import 'package:google_tasks/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:google_tasks/presentation/bloc/task_bloc/tasks_bloc.dart';
import 'package:google_tasks/presentation/cubit/home_page_cubit.dart';
import 'package:google_tasks/presentation/router/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  CurrentTabCubit currentTabCubit = CurrentTabCubit();

  //Bloc.observer = SimpleBlocObserver();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  runApp(MyApp(
    cubit: currentTabCubit,
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
  const MyApp({super.key, required this.sp, required this.cubit});

  final SharedPreferences sp;
  final CurrentTabCubit cubit;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => TaskRepositoryImpl(),
        ),
        RepositoryProvider(
            create: (context) => SharedPrefRepositoryImpl(sp: sp)),
        RepositoryProvider(create: (_) => CategoryRepositoryImpl()),
        RepositoryProvider(create: (_) => AuthRepositoryImpl())
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
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Google Tasks Copy',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme:
                  ColorScheme.fromSeed(seedColor: const Color(0xFF0099cc)),
            ),
            routerConfig: router,
          ),
        );
      }),
    );
  }
}
