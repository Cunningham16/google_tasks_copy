import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/domain/use_cases/login_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:google_tasks/domain/value_objects/email.dart';
import 'package:google_tasks/domain/value_objects/password.dart';
import 'package:google_tasks/utils/enums/email_status.dart';
import 'package:google_tasks/utils/enums/form_status.dart';
import 'package:google_tasks/utils/enums/password_status.dart';

part "login_state.dart";

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase,
        super(const LoginState());

  void emailChanged(String value) {
    try {
      Email email = Email((email) => email..value = value);
      emit(state.copyWith(email: email, emailStatus: EmailStatus.valid));
    } on ArgumentError catch (e) {
      emit(state.copyWith(emailStatus: EmailStatus.invalid));
    }
  }

  void passwordChanged(String value) {
    try {
      Password password = Password((password) => password..value = value);
      emit(state.copyWith(
          password: password, passwordStatus: PasswordStatus.valid));
    } on ArgumentError catch (e) {
      emit(state.copyWith(emailStatus: EmailStatus.invalid));
    }
  }

  Future<void> login() async {
    try {
      await _loginUseCase(
          LoginParams(email: state.email!, password: state.password!));
      emit(state.copyWith(formStatus: FormStatus.submissionSuccess));
    } catch (e) {
      emit(state.copyWith(formStatus: FormStatus.submissionFailure));
    }
  }
}
