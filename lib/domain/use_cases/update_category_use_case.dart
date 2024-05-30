import 'package:google_tasks/data/entities/task_category/task_category.dart';
import 'package:google_tasks/domain/repositories/category_repository.dart';

class UpdateCategoryUseCase {
  final CategoryRepository categoryRepository;

  const UpdateCategoryUseCase({required this.categoryRepository});

  Future<void> call(UpdateCategoryParams params) async {
    try {
      await categoryRepository.updateCategory(
          params.id, params.modifiedCategory);
    } catch (e) {
      throw Exception(e);
    }
  }
}

class UpdateCategoryParams {
  final String id;
  final TaskCategory modifiedCategory;

  const UpdateCategoryParams(
      {required this.id, required this.modifiedCategory});
}
