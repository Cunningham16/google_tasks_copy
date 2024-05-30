import 'package:google_tasks/data/entities/app_user/app_user.dart';
import 'package:google_tasks/domain/repositories/auth_repository.dart';

class StreamAppUserUseCase {
  final AuthRepository authRepository;

  StreamAppUserUseCase({required this.authRepository});

  Stream<AppUser> call() {
    try {
      return authRepository.userInfo;
    } catch (e) {
      throw Exception(e);
    }
  }
}
