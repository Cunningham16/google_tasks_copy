import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/data/entities/category.entity.dart';
import 'package:google_tasks/data/entities/task.entity.dart';

class TaskRepository {
  TaskRepository({
    required AppDatabase db,
  }) : _db = db;

  final AppDatabase _db;

  Future<void> deleteTask(int id) => _db.deleleTask(id);

  Future<void> saveTask(TaskEntity entity) => _db.saveTask(entity);

  Future<void> updateTask(int id, TaskEntity taskEntity) =>
      _db.updateTask(id, taskEntity);

  Future<List<TaskEntity>> getTasksByCategory(int categoryId) =>
      _db.queryTasksByCategory(categoryId);

  Future<TaskEntity?> getSingleTask(int taskId) => _db.querySingleTask(taskId);

  Future<List<TaskEntity>> getTasksByFavorites() => _db.queryTaskByFavorites();

  Stream<List<TaskEntity>> getAllTasks() => _db.queryAllTasks();

  Future<void> saveCategory(CategoryEntity entity) => _db.saveCategory(entity);

  Future<void> updateCategory(id, newCategory) =>
      _db.updateCategory(id, newCategory);

  Future<void> deleteCategory(int id) => _db.deleteCategory(id);

  Stream<List<CategoryEntity>> watchCategories() => _db.watchCategories();

  Future<List<CategoryEntity>> getCategories() => _db.getCategories();
}
