import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_provider/go_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_tasks/domain/use_cases/category/delete_category_use_case.dart';
import 'package:google_tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:google_tasks/domain/use_cases/delete_tasks_by_category_use_case.dart';
import 'package:google_tasks/domain/use_cases/delete_tasks_by_completed_use_case.dart';
import 'package:google_tasks/domain/use_cases/get_single_task_use_case.dart';
import 'package:google_tasks/domain/use_cases/login_use_case.dart';
import 'package:google_tasks/domain/use_cases/register_use_case.dart';
import 'package:google_tasks/domain/use_cases/category/save_category_use_case.dart';
import 'package:google_tasks/domain/use_cases/reorder_task_list_use_case.dart';
import 'package:google_tasks/domain/use_cases/save_task_use_case.dart';
import 'package:google_tasks/domain/use_cases/category/update_category_use_case.dart';
import 'package:google_tasks/domain/use_cases/update_task_use_case.dart';
import 'package:google_tasks/domain/use_cases/watch_all_tasks_use_case.dart';
import 'package:google_tasks/domain/use_cases/category/watch_categories_use_case.dart';
import 'package:google_tasks/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:google_tasks/presentation/bloc/login_cubit/login_cubit.dart';
import 'package:google_tasks/presentation/bloc/register_cubit/register_cubit.dart';
import 'package:google_tasks/presentation/bloc/task_bloc/tasks_bloc.dart';
import 'package:google_tasks/presentation/cubit/home_page_cubit.dart';
import 'package:google_tasks/presentation/screens/auth_screen.dart';
import 'package:google_tasks/presentation/screens/screens.dart';
import 'package:google_tasks/service_locator.dart';

final GoRouter router = GoRouter(
  initialLocation: HomeScreen.route,
  routes: [
    GoRoute(
      path: AuthScreen.route,
      builder: (context, state) => MultiBlocProvider(providers: [
        BlocProvider(
            create: (_) =>
                LoginCubit(loginUseCase: serviceLocator<LoginUseCase>())),
        BlocProvider(
            create: (_) => RegisterCubit(
                registerUseCase: serviceLocator<RegisterUseCase>()))
      ], child: const AuthScreen()),
    ),
    GoProviderRoute(
        providers: [
          BlocProvider(
              create: (_) => TaskBloc(
                  saveTaskUseCase: serviceLocator<SaveTaskUseCase>(),
                  deleteTaskUseCase: serviceLocator<DeleteTaskUseCase>(),
                  updateTaskUseCase: serviceLocator<UpdateTaskUseCase>(),
                  watchAllTasksUseCase: serviceLocator<WatchAllTasksUseCase>(),
                  getSingleTaskUseCase: serviceLocator<GetSingleTaskUseCase>(),
                  deleteTasksByCategoryUseCase:
                      serviceLocator<DeleteTasksByCategoryUseCase>(),
                  deleteTasksByCompletedUseCase:
                      serviceLocator<DeleteTasksByCompletedUseCase>(),
                  reorderTaskListUseCase:
                      serviceLocator<ReorderTaskListUseCase>())),
          BlocProvider(
              create: (_) => CategoryBloc(
                  deleteCategoryUseCase:
                      serviceLocator<DeleteCategoryUseCase>(),
                  saveCategoryUseCase: serviceLocator<SaveCategoryUseCase>(),
                  updateCategoryUseCase:
                      serviceLocator<UpdateCategoryUseCase>(),
                  watchCategoriesUseCase:
                      serviceLocator<WatchCategoriesUseCase>())),
          BlocProvider(create: (_) => CurrentTabCubit())
        ],
        path: HomeScreen.route,
        name: HomeScreen.route,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: TaskDetails.route,
            name: "details",
            builder: (context, state) => TaskDetails(
              taskId: state.pathParameters["id"] as String,
            ),
          ),
          GoRoute(
            path: CreateListScreen.route,
            name: CreateListScreen.route,
            builder: (context, state) => CreateListScreen(
              name: state.uri.queryParameters["name"],
            ),
          ),
        ]),
  ],
  redirect: (context, state) {
    bool isLogged = FirebaseAuth.instance.currentUser != null;
    bool isLogging = state.matchedLocation == AuthScreen.route;

    if (!isLogged) {
      return AuthScreen.route;
    }

    if (isLogging) {
      return HomeScreen.route;
    }

    return null;
  },
);
