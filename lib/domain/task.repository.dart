import 'package:google_tasks/data/database/database.dart';

class TaskRepository {
  TaskRepository({
    required AppDatabase db,
  }) : _db = db;

  final AppDatabase _db;

  Future<void> deleteTask(int id) => _db.deleleTask(id);

  Future<void> saveTask(TaskItemsCompanion entity) => _db.saveTask(entity);

  Future<void> updateTask(int id, TaskItemsCompanion taskItem) =>
      _db.updateTask(id, taskItem);

  Future<TaskItem?> getSingleTask(int taskId) => _db.querySingleTask(taskId);

  Future<List<TaskItem>> getTasksByFavorites() => _db.queryTaskByFavorites();

  Stream<List<TaskItem>> watchAllTasks() => _db.watchAllTasks();

  Future<void> saveCategory(TaskCategoriesCompanion entity) =>
      _db.saveCategory(entity);

  Future<void> updateCategory(
          id, TaskCategoriesCompanion taskCategoriesCompanion) =>
      _db.updateCategory(id, taskCategoriesCompanion);

  Future<void> deleteCategory(int id) => _db.deleteCategory(id);

  Stream<List<TaskCategory>> watchCategories() => _db.watchCategories();

  Future<List<TaskCategory>> getCategories() => _db.getCategories();
}
