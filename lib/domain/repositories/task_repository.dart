import 'package:google_tasks/data/database/database.dart';

abstract class TaskRepository {
  Future<void> deleteTask(int id);

  Future<void> deleteAllCompletedTasks(int categoryId);

  Future<void> saveTask(TaskItemsCompanion entity);

  Future<void> updateTask(int id, TaskItemsCompanion taskItem);

  Stream<TaskItem> watchSingleTask(int taskId);

  Future<void> saveCategory(TaskCategoriesCompanion entity);

  Future<void> updateCategory(
      id, TaskCategoriesCompanion taskCategoriesCompanion);

  Future<void> deleteCategory(int id);

  Stream<List<TaskCategory>> watchCategories();

  Future<TaskCategory> getCategoryById(int id);

  Stream<List<TaskItem>> watchAllTasks();
}
