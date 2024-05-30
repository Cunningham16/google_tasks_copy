import 'package:google_tasks/data/entities/task_item/task_item.dart';

abstract class TaskRepository {
  Future<void> deleteTask(String id);

  Future<void> deleteAllCompletedTasks(String categoryId);

  Future<void> saveTask(TaskItem taskItem);

  Future<void> updateTask(String id, TaskItem taskItem);

  Future<TaskItem> getSingleTask(String id);

  Stream<List<TaskItem>> watchAllTasks();
}
