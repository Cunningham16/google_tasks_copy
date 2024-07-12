import 'package:google_tasks/data/entities/task_item/task_item.dart';
import 'package:google_tasks/domain/repositories/auth_repository.dart';
import 'package:google_tasks/domain/repositories/task_repository.dart';
import 'package:uuid/uuid.dart';

class SaveTaskUseCase {
  final TaskRepository taskRepository;
  final AuthRepository authRepository;

  const SaveTaskUseCase(
      {required this.taskRepository, required this.authRepository});

  Future<void> call(SaveTaskParams params) async {
    try {
      final String uuid = const Uuid().v4();
      await taskRepository.saveTask(TaskItem(
          id: uuid,
          userId: authRepository.userInfo.id,
          title: params.title,
          content: params.content,
          category: params.category,
          isCompleted: params.isCompleted,
          isFavorite: params.isFavorite,
          position: params.position));
    } catch (e) {
      throw Exception(e);
    }
  }
}

class SaveTaskParams {
  final String title;
  final String? content;
  final String category;
  final bool isCompleted;
  final bool isFavorite;
  final DateTime? date;
  final DateTime? whenMarked;
  final int position;

  const SaveTaskParams(
      {required this.title,
      this.content,
      required this.category,
      required this.isCompleted,
      required this.isFavorite,
      this.date,
      this.whenMarked,
      required this.position});
}
