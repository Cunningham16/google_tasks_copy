import 'package:google_tasks/data/entities/task_category/task_category.dart';
import 'package:google_tasks/domain/repositories/category_repository.dart';
import 'package:google_tasks/utils/enums/sort_types.dart';
import 'package:uuid/uuid.dart';

class SaveCategoryUseCase {
  final CategoryRepository categoryRepository;

  const SaveCategoryUseCase({required this.categoryRepository});

  Future<void> call(SaveCategoryParams params) async {
    try {
      final uuid = const Uuid().v4();
      await categoryRepository.saveCategory(TaskCategory(
          id: uuid,
          userId: params.userId,
          name: params.name,
          isDeleteable: params.isDeleteable,
          sortType: params.sortType));
    } catch (e) {
      throw Exception(e);
    }
  }
}

class SaveCategoryParams {
  final String userId;
  final String name;
  final bool isDeleteable;
  final SortTypes sortType;

  const SaveCategoryParams(
      {required this.userId,
      required this.name,
      required this.isDeleteable,
      required this.sortType});
}
