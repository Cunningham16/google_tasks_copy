import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_tasks/domain/repositories/auth_repository.dart';
import 'package:google_tasks/domain/value_objects/email.dart';
import 'package:google_tasks/domain/value_objects/password.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase({required this.authRepository});

  Future<UserCredential> call(LoginParams params) async {
    try {
      return await authRepository.login(
          email: params.email, password: params.password);
    } on ArgumentError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e);
    }
  }
}

class LoginParams {
  final Email email;
  final Password password;

  LoginParams({required this.email, required this.password});
}
