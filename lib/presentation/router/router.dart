import 'package:go_router/go_router.dart';
import 'package:google_tasks/presentation/screens/auth_screen.dart';
import 'package:google_tasks/presentation/screens/screens.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(
    path: HomeScreen.route,
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    path: TaskDetails.route,
    builder: (context, state) => TaskDetails(
      taskId: state.pathParameters["id"] as int,
    ),
  ),
  GoRoute(
    path: CreateListScreen.route,
    builder: (context, state) => CreateListScreen(
      name: state.uri.queryParameters["name"],
    ),
  ),
  GoRoute(
    path: AuthScreen.route,
    builder: (context, state) => const AuthScreen(),
  )
]);
