import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_tasks/data/entities/app_user/app_user.dart';
import 'package:google_tasks/domain/repositories/auth_repository.dart';
import 'package:google_tasks/domain/value_objects/email.dart';
import 'package:google_tasks/domain/value_objects/password.dart';

class AuthRepositoryImpl implements AuthRepository {
  FirebaseAuth authInstance = FirebaseAuth.instance;

  @override
  Stream<AppUser> get userInfoStream {
    return authInstance.authStateChanges().map((user) {
      return AppUser(
          id: user!.uid, email: user.email ?? '', name: user.displayName!);
    });
  }

  @override
  AppUser get userInfo {
    final currentUser = authInstance.currentUser!;
    return AppUser(
        id: currentUser.uid,
        email: currentUser.email!,
        name: currentUser.displayName!);
  }

  @override
  Future<UserCredential> login(
      {required Email email, required Password password}) async {
    try {
      UserCredential userCredential =
          await authInstance.signInWithEmailAndPassword(
              email: email.value, password: password.value);
      return userCredential;
    } catch (e) {
      throw Exception(e.hashCode);
    }
  }

  @override
  Future<UserCredential> register(
      {required Email email,
      required Password password,
      required String name}) async {
    try {
      UserCredential userCredential =
          await authInstance.createUserWithEmailAndPassword(
              email: email.value, password: password.value);
      await userCredential.user!.updateDisplayName(name);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await authInstance.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
}
