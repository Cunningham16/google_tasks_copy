import 'package:google_tasks/data/entities/task_item/task_item.dart';
import 'package:google_tasks/domain/repositories/task_repository.dart';

class WatchAllTasksUseCase {
  final TaskRepository taskRepository;

  const WatchAllTasksUseCase({required this.taskRepository});

  Stream<List<TaskItem>> call() {
    try {
      return taskRepository.watchAllTasks();
    } catch (e) {
      throw Exception(e);
    }
  }
}
