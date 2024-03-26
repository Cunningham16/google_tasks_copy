import 'package:go_router/go_router.dart';

import '../screens/create_list.dart';
import '../screens/home_page.dart';
import '../screens/task_details.dart';
import 'routes.dart';

final GoRouter appRouter = GoRouter(routes: <RouteBase>[
  GoRoute(
      path: RoutesLocation.home,
      builder: (context, state) => const HomeScreen(),
      routes: <RouteBase>[
        GoRoute(
          path: RoutesLocation.taskDetails,
          builder: (context, state) => const TaskDetails(),
        ),
        GoRoute(
          path: RoutesLocation.createList,
          builder: (context, state) => const CreateListScreen(),
        )
      ])
]);
