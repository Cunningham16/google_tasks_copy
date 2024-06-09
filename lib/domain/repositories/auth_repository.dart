import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_tasks/data/entities/app_user/app_user.dart';
import 'package:google_tasks/domain/value_objects/email.dart';
import 'package:google_tasks/domain/value_objects/password.dart';

abstract class AuthRepository {
  Stream<AppUser> get userInfoStream;

  AppUser get userInfo;

  Future<UserCredential> login(
      {required Email email, required Password password});

  Future<UserCredential> register(
      {required Email email, required Password password, required String name});

  Future<void> logout();
}
