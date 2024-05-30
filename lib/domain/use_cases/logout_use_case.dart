import 'package:google_tasks/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository authRepository;

  LogoutUseCase({required this.authRepository});

  Future<void> call() async {
    try {
      await authRepository.logout();
    } catch (e) {
      throw Exception(e);
    }
  }
}
