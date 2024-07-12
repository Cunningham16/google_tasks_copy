import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_tasks/data/entities/app_user/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser> get userInfoStream;

  AppUser get userInfo;

  Future<UserCredential> login(
      {required String email, required String password});

  Future<UserCredential> register(
      {required String email, required String password, required String name});

  Future<void> logout();
}
