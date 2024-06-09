import 'package:google_tasks/domain/repositories/task_repository.dart';

class DeleteTasksByCompletedUseCase {
  final TaskRepository taskRepository;

  DeleteTasksByCompletedUseCase({required this.taskRepository});

  Future<void> call({required String categoryId}) async {
    try {
      await taskRepository.deleteAllCompletedTasks(categoryId);
    } catch (e) {
      throw Exception(e);
    }
  }
}
