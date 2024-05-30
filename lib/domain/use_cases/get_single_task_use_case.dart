import 'package:google_tasks/data/entities/task_item/task_item.dart';
import 'package:google_tasks/domain/repositories/task_repository.dart';

class GetSingleTaskUseCase {
  final TaskRepository taskRepository;

  const GetSingleTaskUseCase({required this.taskRepository});

  Future<TaskItem> call(String id) async {
    try {
      return await taskRepository.getSingleTask(id);
    } catch (e) {
      throw Exception(e);
    }
  }
}
