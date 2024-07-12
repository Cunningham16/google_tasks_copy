import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_tasks/data/entities/app_user/app_user.dart';
import 'package:google_tasks/domain/repositories/auth_repository.dart';

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
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await authInstance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<UserCredential> register(
      {required String email,
      required String password,
      required String name}) async {
    try {
      UserCredential userCredential = await authInstance
          .createUserWithEmailAndPassword(email: email, password: password);
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
