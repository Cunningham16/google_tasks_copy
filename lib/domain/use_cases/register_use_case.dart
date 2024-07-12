import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_tasks/data/entities/task_category/task_category.dart';
import 'package:google_tasks/domain/repositories/auth_repository.dart';
import 'package:google_tasks/domain/repositories/category_repository.dart';
import 'package:google_tasks/utils/enums/sort_types.dart';
import 'package:uuid/uuid.dart';

class RegisterUseCase {
  final AuthRepository authRepository;
  final CategoryRepository categoryRepository;

  RegisterUseCase(
      {required this.authRepository, required this.categoryRepository});

  Future<UserCredential> call(RegisterParams params) async {
    try {
      UserCredential userCredential = await authRepository.register(
          email: params.email, password: params.password, name: params.name);
      final uuidTasks = const Uuid().v4();
      final uuidFavorite = const Uuid().v4();

      await categoryRepository.saveCategory(TaskCategory(
          id: uuidFavorite,
          userId: userCredential.user!.uid,
          name: "",
          isDeleteable: false,
          sortType: SortTypes.byDate,
          isFavoriteFlag: true));

      await categoryRepository.saveCategory(TaskCategory(
          id: uuidTasks,
          userId: userCredential.user!.uid,
          name: "Мои задачи",
          isDeleteable: false,
          sortType: SortTypes.byOwn,
          isFavoriteFlag: false));

      return userCredential;
    } catch (e) {
      throw Exception(e);
    }
  }
}

class RegisterParams {
  final String name;
  final String email;
  final String password;

  const RegisterParams(
      {required this.name, required this.email, required this.password});
}
