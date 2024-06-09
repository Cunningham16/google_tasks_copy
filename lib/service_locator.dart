import 'package:get_it/get_it.dart';
import 'package:google_tasks/data/repositories/auth_repository_impl.dart';
import 'package:google_tasks/data/repositories/category_repository_impl.dart';
import 'package:google_tasks/data/repositories/shared_pref_repository_impl.dart';
import 'package:google_tasks/data/repositories/task_repository_impl.dart';
import 'package:google_tasks/domain/repositories/auth_repository.dart';
import 'package:google_tasks/domain/repositories/category_repository.dart';
import 'package:google_tasks/domain/repositories/shared_pref_repository.dart';
import 'package:google_tasks/domain/repositories/task_repository.dart';
import 'package:google_tasks/domain/use_cases/delete_category_use_case.dart';
import 'package:google_tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:google_tasks/domain/use_cases/delete_tasks_by_category_use_case.dart';
import 'package:google_tasks/domain/use_cases/delete_tasks_by_completed_use_case.dart';
import 'package:google_tasks/domain/use_cases/get_single_task_use_case.dart';
import 'package:google_tasks/domain/use_cases/login_use_case.dart';
import 'package:google_tasks/domain/use_cases/logout_use_case.dart';
import 'package:google_tasks/domain/use_cases/register_use_case.dart';
import 'package:google_tasks/domain/use_cases/save_category_use_case.dart';
import 'package:google_tasks/domain/use_cases/save_task_use_case.dart';
import 'package:google_tasks/domain/use_cases/stream_app_user_use_case.dart';
import 'package:google_tasks/domain/use_cases/update_category_use_case.dart';
import 'package:google_tasks/domain/use_cases/update_task_use_case.dart';
import 'package:google_tasks/domain/use_cases/watch_all_tasks_use_case.dart';
import 'package:google_tasks/domain/use_cases/watch_categories_use_case.dart';
import 'package:google_tasks/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:google_tasks/presentation/bloc/login_cubit/login_cubit.dart';
import 'package:google_tasks/presentation/bloc/register_cubit/register_cubit.dart';
import 'package:google_tasks/presentation/bloc/task_bloc/tasks_bloc.dart';
import 'package:google_tasks/presentation/cubit/home_page_cubit.dart';

//TODO: Переделать руты

final serviceLocator = GetIt.instance;

initServiceLocator() async {
  //Blocs
  serviceLocator.registerFactory<TaskBloc>(() => TaskBloc(
      saveTaskUseCase: serviceLocator(),
      deleteTaskUseCase: serviceLocator(),
      updateTaskUseCase: serviceLocator(),
      watchAllTasksUseCase: serviceLocator(),
      getSingleTaskUseCase: serviceLocator(),
      deleteTasksByCategoryUseCase: serviceLocator(),
      deleteTasksByCompletedUseCase: serviceLocator()));

  serviceLocator.registerFactory<CategoryBloc>(() => CategoryBloc(
      deleteCategoryUseCase: serviceLocator(),
      saveCategoryUseCase: serviceLocator(),
      updateCategoryUseCase: serviceLocator(),
      watchCategoriesUseCase: serviceLocator()));

  serviceLocator
      .registerFactory(() => RegisterCubit(registerUseCase: serviceLocator()));

  serviceLocator
      .registerFactory(() => LoginCubit(loginUseCase: serviceLocator()));

  serviceLocator.registerFactory(() => CurrentTabCubit());

  //Repositories
  serviceLocator
      .registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl());

  serviceLocator.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl());

  serviceLocator
      .registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  serviceLocator.registerLazySingleton<SharedPreferencesRepository>(
      () => SharedPrefRepositoryImpl());

  //Use cases
  serviceLocator.registerLazySingleton(
      () => DeleteCategoryUseCase(categoryRepository: serviceLocator()));

  serviceLocator.registerLazySingleton(
      () => DeleteTaskUseCase(taskRepository: serviceLocator()));

  serviceLocator.registerLazySingleton(
      () => DeleteTasksByCategoryUseCase(taskRepository: serviceLocator()));

  serviceLocator.registerLazySingleton(
      () => DeleteTasksByCompletedUseCase(taskRepository: serviceLocator()));

  serviceLocator.registerLazySingleton(
      () => GetSingleTaskUseCase(taskRepository: serviceLocator()));

  serviceLocator.registerLazySingleton(
      () => LoginUseCase(authRepository: serviceLocator()));

  serviceLocator.registerLazySingleton(
      () => LogoutUseCase(authRepository: serviceLocator()));

  serviceLocator.registerLazySingleton(() => RegisterUseCase(
      authRepository: serviceLocator(), categoryRepository: serviceLocator()));

  serviceLocator.registerLazySingleton(() => SaveCategoryUseCase(
      categoryRepository: serviceLocator(), authRepository: serviceLocator()));

  serviceLocator.registerLazySingleton(() => SaveTaskUseCase(
      taskRepository: serviceLocator(), authRepository: serviceLocator()));

  serviceLocator.registerLazySingleton(
      () => StreamAppUserUseCase(authRepository: serviceLocator()));

  serviceLocator.registerLazySingleton(
      () => UpdateCategoryUseCase(categoryRepository: serviceLocator()));

  serviceLocator.registerLazySingleton(
      () => UpdateTaskUseCase(taskRepository: serviceLocator()));

  serviceLocator.registerLazySingleton(
      () => WatchAllTasksUseCase(taskRepository: serviceLocator()));

  serviceLocator.registerLazySingleton(
      () => WatchCategoriesUseCase(categoryRepository: serviceLocator()));
}
