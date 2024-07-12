import 'package:google_tasks/data/entities/task_item/task_item.dart';
import 'package:google_tasks/domain/repositories/task_repository.dart';

class ReorderTaskListUseCase {
  final TaskRepository taskRepository;

  ReorderTaskListUseCase({required this.taskRepository});

  Future<void> call(ReorderTaskListParams params) async {
    try {
      await taskRepository.reorderListTasks(
          params.categoryId, params.taskItems);
    } catch (e) {
      throw Exception(e);
    }
  }
}

class ReorderTaskListParams {
  final String categoryId;
  final List<TaskItem> taskItems;

  ReorderTaskListParams({required this.categoryId, required this.taskItems});
}
