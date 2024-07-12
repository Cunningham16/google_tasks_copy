import 'package:google_tasks/domain/repositories/auth_repository.dart';
import 'package:google_tasks/domain/repositories/shared_pref_repository.dart';

class LogoutUseCase {
  final AuthRepository authRepository;
  final SharedPreferencesRepository sharedPreferencesRepository;

  LogoutUseCase({
    required this.authRepository,
    required this.sharedPreferencesRepository,
  });

  Future<void> call() async {
    try {
      await authRepository.logout();
      sharedPreferencesRepository.setLastTab(0);
    } catch (e) {
      throw Exception(e);
    }
  }
}
