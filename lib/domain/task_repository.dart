import 'package:google_tasks/data/database/database.dart';

class TaskRepository {
  TaskRepository({
    required AppDatabase db,
  }) : _db = db;

  final AppDatabase _db;

  Stream<List<TasksWithCategories>> watchCategoriesWithTasks() =>
      _db.queryCategoriesWithTasks();

  Future<void> deleteTask(int id) => _db.deleteTask(id);

  Future<void> deleteAllCompletedTasks(int categoryId) =>
      _db.clearCompletedTasks(categoryId);

  Future<void> saveTask(TaskItemsCompanion entity) => _db.saveTask(entity);

  Future<void> updateTask(int id, TaskItemsCompanion taskItem) =>
      _db.updateTask(id, taskItem);

  Stream<TaskItem> watchSingleTask(int taskId) => _db.watchSingleTask(taskId);

  Future<void> saveCategory(TaskCategoriesCompanion entity) =>
      _db.saveCategory(entity);

  Future<void> updateCategory(
          id, TaskCategoriesCompanion taskCategoriesCompanion) =>
      _db.updateCategory(id, taskCategoriesCompanion);

  Future<void> deleteCategory(int id) => _db.deleteCategory(id);

  Stream<List<TaskCategory>> watchCategories() => _db.watchCategories();

  Future<TaskCategory> getCategoryById(int id) => _db.getCategoryById(id);

  Stream<List<TaskItem>> watchAllTasks() => _db.watchTasks();
}
