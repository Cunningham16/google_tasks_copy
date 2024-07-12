import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_tasks/domain/use_cases/login_use_case.dart';
import 'package:equatable/equatable.dart';
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
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );

    if (!emailRegExp.hasMatch(value)) {
      emit(state.copyWith(emailStatus: EmailStatus.invalid));
    } else {
      emit(state.copyWith(email: value, emailStatus: EmailStatus.valid));
    }
  }

  void passwordChanged(String value) {
    //if (value.length < 8) {
    //  throw ArgumentError('Password must be at least 8 characters');
    //}

    final RegExp passwordRegExp = RegExp(
      r'^[a-zA-Z0-9]*$',
    );

    if (!passwordRegExp.hasMatch(value)) {
      emit(state.copyWith(emailStatus: EmailStatus.invalid));
    } else {
      emit(state.copyWith(
          password: value, passwordStatus: PasswordStatus.valid));
    }
  }

  Future<void> login() async {
    if (!(state.emailStatus == EmailStatus.valid) ||
        !(state.passwordStatus == PasswordStatus.valid)) {
      emit(state.copyWith(formStatus: FormStatus.invalid));
      emit(state.copyWith(formStatus: FormStatus.initial));
      return;
    }

    emit(state.copyWith(formStatus: FormStatus.submissionInProgress));
    if (isClosed) return;
    try {
      await _loginUseCase(
          LoginParams(email: state.email!, password: state.password!));
      emit(state.copyWith(formStatus: FormStatus.submissionSuccess));
    } on ArgumentError {
      emit(state.copyWith(formStatus: FormStatus.submissionFailure));
    }
  }
}
