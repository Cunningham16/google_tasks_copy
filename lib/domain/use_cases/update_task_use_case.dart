import 'package:google_tasks/data/entities/task_item/task_item.dart';
import 'package:google_tasks/domain/repositories/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository taskRepository;

  const UpdateTaskUseCase({required this.taskRepository});

  Future<void> call(UpdateTaskParams params) async {
    try {
      await taskRepository.updateTask(params.id, params.taskItem);
    } catch (e) {
      throw Exception(e);
    }
  }
}

class UpdateTaskParams {
  final String id;
  final TaskItem taskItem;

  const UpdateTaskParams({required this.id, required this.taskItem});
}
