part of "login_cubit.dart";

class LoginState extends Equatable {
  final String? email;
  final String? password;
  final FormStatus formStatus;
  final EmailStatus emailStatus;
  final PasswordStatus passwordStatus;

  const LoginState(
      {this.email,
      this.password,
      this.emailStatus = EmailStatus.unknown,
      this.formStatus = FormStatus.initial,
      this.passwordStatus = PasswordStatus.unknown});

  LoginState copyWith({
    String? email,
    String? password,
    FormStatus? formStatus,
    EmailStatus? emailStatus,
    PasswordStatus? passwordStatus,
  }) {
    return LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        emailStatus: emailStatus ?? this.emailStatus,
        formStatus: formStatus ?? this.formStatus,
        passwordStatus: passwordStatus ?? this.passwordStatus);
  }

  @override
  List<Object?> get props =>
      [email, password, emailStatus, passwordStatus, formStatus];
}
