import 'package:google_tasks/domain/repositories/task_repository.dart';

class DeleteTasksByCategoryUseCase {
  final TaskRepository taskRepository;

  DeleteTasksByCategoryUseCase({required this.taskRepository});

  Future<void> call({required String categoryId}) async {
    try {
      await taskRepository.deleteTasksByCategory(categoryId);
    } catch (e) {
      throw Exception(e);
    }
  }
}
