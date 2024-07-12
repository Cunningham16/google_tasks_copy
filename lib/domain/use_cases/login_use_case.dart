import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_tasks/domain/repositories/auth_repository.dart';

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
      log(e.toString());
      throw Exception(e);
    }
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
