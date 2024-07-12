part of "register_cubit.dart";

class RegisterState extends Equatable {
  final String? name;
  final String? email;
  final String? password;
  final FormStatus formStatus;
  final EmailStatus emailStatus;
  final PasswordStatus passwordStatus;

  const RegisterState(
      {this.name,
      this.email,
      this.password,
      this.emailStatus = EmailStatus.unknown,
      this.formStatus = FormStatus.initial,
      this.passwordStatus = PasswordStatus.unknown});

  RegisterState copyWith({
    String? name,
    String? email,
    String? password,
    FormStatus? formStatus,
    EmailStatus? emailStatus,
    PasswordStatus? passwordStatus,
  }) {
    return RegisterState(
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        emailStatus: emailStatus ?? this.emailStatus,
        formStatus: formStatus ?? this.formStatus,
        passwordStatus: passwordStatus ?? this.passwordStatus);
  }

  @override
  List<Object?> get props =>
      [name, email, password, emailStatus, passwordStatus, formStatus];
}
