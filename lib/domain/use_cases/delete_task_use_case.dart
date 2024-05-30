import 'package:google_tasks/domain/repositories/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository taskRepository;

  const DeleteTaskUseCase({required this.taskRepository});

  Future<void> call(String id) async {
    try {
      await taskRepository.deleteTask(id);
    } catch (e) {
      throw Exception(e);
    }
  }
}
