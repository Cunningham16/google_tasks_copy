import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_tasks/domain/use_cases/register_use_case.dart';
import 'package:google_tasks/domain/value_objects/email.dart';
import 'package:google_tasks/domain/value_objects/password.dart';
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
    try {
      Email email = Email((email) => email..value = value);
      emit(state.copyWith(email: email, emailStatus: EmailStatus.valid));
    } on ArgumentError {
      emit(state.copyWith(emailStatus: EmailStatus.invalid));
    }
  }

  void passwordChanged(String value) {
    try {
      Password password = Password((password) => password..value = value);
      emit(state.copyWith(
          password: password, passwordStatus: PasswordStatus.valid));
    } on ArgumentError {
      emit(state.copyWith(emailStatus: EmailStatus.invalid));
    }
  }

  Future<void> register() async {
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
