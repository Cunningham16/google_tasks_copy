import 'package:google_tasks/domain/repositories/category_repository.dart';

class DeleteCategoryUseCase {
  final CategoryRepository categoryRepository;

  const DeleteCategoryUseCase({required this.categoryRepository});

  Future<void> call(String categoryId) async {
    try {
      await categoryRepository.deleteCategory(categoryId);
    } catch (e) {
      throw Exception(e);
    }
  }
}
