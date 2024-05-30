import 'package:google_tasks/data/entities/task_category/task_category.dart';
import 'package:google_tasks/domain/repositories/category_repository.dart';

class WatchCategoriesUseCase {
  final CategoryRepository categoryRepository;

  const WatchCategoriesUseCase({required this.categoryRepository});

  Stream<List<TaskCategory>> call() {
    try {
      return categoryRepository.watchCategories();
    } catch (e) {
      throw Exception(e);
    }
  }
}
