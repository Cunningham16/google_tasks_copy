import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_tasks/domain/repositories/auth_repository.dart';
import 'package:google_tasks/domain/value_objects/email.dart';
import 'package:google_tasks/domain/value_objects/password.dart';

class RegisterUseCase {
  final AuthRepository authRepository;

  RegisterUseCase({required this.authRepository});

  Future<UserCredential> call(RegisterParams params) async {
    try {
      return await authRepository.register(
          email: params.email, password: params.password, name: params.name);
    } catch (e) {
      throw Exception(e);
    }
  }
}

class RegisterParams {
  final String name;
  final Email email;
  final Password password;

  const RegisterParams(this.name, this.email, this.password);
}
