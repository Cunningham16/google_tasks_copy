import 'package:google_tasks/data/entities/task_category/task_category.dart';

abstract class CategoryRepository {
  Future<void> saveCategory(TaskCategory entity);

  Future<void> updateCategory(String id, TaskCategory modifiedCategory);

  Future<void> deleteCategory(String id);

  Stream<List<TaskCategory>> watchCategories(String userId);
}
