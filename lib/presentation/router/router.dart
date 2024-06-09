import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_provider/go_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_tasks/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:google_tasks/presentation/bloc/login_cubit/login_cubit.dart';
import 'package:google_tasks/presentation/bloc/register_cubit/register_cubit.dart';
import 'package:google_tasks/presentation/bloc/task_bloc/tasks_bloc.dart';
import 'package:google_tasks/presentation/screens/auth_screen.dart';
import 'package:google_tasks/presentation/screens/screens.dart';
import 'package:google_tasks/service_locator.dart';

final GoRouter router = GoRouter(
  initialLocation: FirebaseAuth.instance.currentUser != null
      ? HomeScreen.route
      : AuthScreen.route,
  routes: [
    GoProviderRoute(
        providers: [
          BlocProvider.value(
              value: serviceLocator<TaskBloc>()
                ..add(const TaskSubscribtionRequested())),
          BlocProvider.value(
              value: serviceLocator<CategoryBloc>()
                ..add(const CategorySubscriptionRequested()))
        ],
        path: HomeScreen.route,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: TaskDetails.route,
            builder: (context, state) => TaskDetails(
              taskId: state.pathParameters["id"] as String,
            ),
          ),
          GoRoute(
            path: CreateListScreen.route,
            builder: (context, state) => CreateListScreen(
              name: state.uri.queryParameters["name"],
            ),
          ),
        ]),
    GoRoute(
      path: AuthScreen.route,
      builder: (context, state) => MultiBlocProvider(providers: [
        BlocProvider.value(value: serviceLocator<RegisterCubit>()),
        BlocProvider.value(value: serviceLocator<LoginCubit>())
      ], child: const AuthScreen()),
    )
  ],
  redirect: (context, state) {
    final bool loggedIn = FirebaseAuth.instance.currentUser != null;
    if (!loggedIn) {
      return AuthScreen.route;
    }
    return null;
  },
);
