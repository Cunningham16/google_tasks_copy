import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_tasks/presentation/components/custom_textfield.dart';

enum AuthScreenMode { login, register }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  static String get route => "/auth";

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  AuthScreenMode mode = AuthScreenMode.login;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 60,
                ),
                const FlutterLogo(
                  size: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Добро пожаловать!",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(
                  height: 30,
                ),
                if (mode == AuthScreenMode.register)
                  CustomTextField(
                    controller: nameController,
                    labelText: "Имя",
                  ),
                if (mode == AuthScreenMode.register)
                  const SizedBox(
                    height: 10,
                  ),
                CustomTextField(
                  controller: emailController,
                  labelText: "Адрес электронной почты",
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: passwordController,
                  obscureText: true,
                  labelText: "Пароль",
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () async {
                    AuthService authService = AuthService();
                    try {
                      if (mode == AuthScreenMode.register) {
                        await authService.register(emailController.text,
                            passwordController.text, nameController.text);
                      } else if (mode == AuthScreenMode.login) {
                        await authService.login(
                            emailController.text, passwordController.text);
                      }
                      if (context.mounted) {
                        context.go(HomeScreen.route);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) => Text(e.toString()),
                        );
                      }
                    }
                  },
                  style: ButtonStyle(
                      shape: const MaterialStatePropertyAll(LinearBorder()),
                      backgroundColor:
                          const MaterialStatePropertyAll(Color(0xFF50A8EB)),
                      minimumSize:
                          const MaterialStatePropertyAll(Size(300, 48)),
                      maximumSize: MaterialStatePropertyAll(
                          Size(MediaQuery.of(context).size.width * 0.9, 48))),
                  child: Text(
                      mode == AuthScreenMode.register
                          ? "Зарегистрироваться"
                          : "Войти",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.white)),
                ),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                    text: TextSpan(
                        text: mode == AuthScreenMode.login
                            ? "Нет аккаунта? "
                            : "Есть аккаунт? ",
                        style: const TextStyle(color: Colors.black),
                        children: [
                      TextSpan(
                        style: const TextStyle(color: Color(0xFF50A8EB)),
                        text: mode == AuthScreenMode.login
                            ? "Регистрация"
                            : "Войти",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => setState(() {
                                if (mode == AuthScreenMode.login) {
                                  mode = AuthScreenMode.register;
                                } else if (mode == AuthScreenMode.register) {
                                  mode = AuthScreenMode.login;
                                }
                              }),
                      )
                    ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
