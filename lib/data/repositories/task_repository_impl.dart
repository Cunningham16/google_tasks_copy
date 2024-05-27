import 'package:google_tasks/data/database/database.dart';
import 'package:google_tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final AppDatabase database;

  const TaskRepositoryImpl({required this.database});

  @override
  Future<void> deleteTask(int id) => database.deleteTask(id);

  @override
  Future<void> deleteAllCompletedTasks(int categoryId) =>
      database.clearCompletedTasks(categoryId);

  @override
  Future<void> saveTask(TaskItemsCompanion entity) => database.saveTask(entity);

  @override
  Future<void> updateTask(int id, TaskItemsCompanion taskItem) =>
      database.updateTask(id, taskItem);

  @override
  Stream<TaskItem> watchSingleTask(int taskId) =>
      database.watchSingleTask(taskId);

  @override
  Future<void> saveCategory(TaskCategoriesCompanion entity) =>
      database.saveCategory(entity);

  @override
  Future<void> updateCategory(
          id, TaskCategoriesCompanion taskCategoriesCompanion) =>
      database.updateCategory(id, taskCategoriesCompanion);

  @override
  Future<void> deleteCategory(int id) => database.deleteCategory(id);

  @override
  Stream<List<TaskCategory>> watchCategories() => database.watchCategories();

  @override
  Future<TaskCategory> getCategoryById(int id) => database.getCategoryById(id);

  @override
  Stream<List<TaskItem>> watchAllTasks() => database.watchTasks();
}
