import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_tasks/domain/use_cases/register_use_case.dart';
import 'package:google_tasks/utils/enums/email_status.dart';
import 'package:google_tasks/utils/enums/form_status.dart';
import 'package:google_tasks/utils/enums/password_status.dart';

part "register_state.dart";

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterCubit({required RegisterUseCase registerUseCase})
      : _registerUseCase = registerUseCase,
        super(const RegisterState());

  void nameChanged(String value) {
    emit(state.copyWith(name: value));
  }

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
    if (value.length < 8) {
      throw ArgumentError('Password must be at least 8 characters');
    }

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

  Future<void> register() async {
    print(state);
    if (!(state.emailStatus == EmailStatus.valid) ||
        !(state.passwordStatus == PasswordStatus.valid)) {
      emit(state.copyWith(formStatus: FormStatus.invalid));
      emit(state.copyWith(formStatus: FormStatus.initial));
      return;
    }

    emit(state.copyWith(formStatus: FormStatus.submissionInProgress));

    try {
      await _registerUseCase(RegisterParams(
          name: state.name!, email: state.email!, password: state.password!));
      emit(state.copyWith(formStatus: FormStatus.submissionSuccess));
    } on ArgumentError {
      emit(state.copyWith(formStatus: FormStatus.submissionFailure));
    }
  }
}
