import 'package:google_tasks/data/entities/task_category/task_category.dart';
import 'package:google_tasks/domain/repositories/auth_repository.dart';
import 'package:google_tasks/domain/repositories/category_repository.dart';
import 'package:google_tasks/utils/enums/sort_types.dart';
import 'package:uuid/uuid.dart';

class SaveCategoryUseCase {
  final CategoryRepository categoryRepository;
  final AuthRepository authRepository;

  const SaveCategoryUseCase(
      {required this.categoryRepository, required this.authRepository});

  Future<void> call({required SaveCategoryParams params}) async {
    try {
      final uuid = const Uuid().v4();
      await categoryRepository.saveCategory(TaskCategory(
          id: uuid,
          userId: authRepository.userInfo.id,
          name: params.name,
          isDeleteable: params.isDeleteable,
          sortType: params.sortType,
          isFavoriteFlag: params.isFavoriteFlag ?? false));
    } catch (e) {
      throw Exception(e);
    }
  }
}

class SaveCategoryParams {
  final String name;
  final bool isDeleteable;
  final SortTypes sortType;
  final bool? isFavoriteFlag;

  const SaveCategoryParams(
      {required this.name,
      required this.isDeleteable,
      required this.sortType,
      this.isFavoriteFlag});
}
