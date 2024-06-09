import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_tasks/presentation/bloc/login_cubit/login_cubit.dart';
import 'package:google_tasks/presentation/components/custom_textfield.dart';
import 'package:google_tasks/presentation/screens/home_screen.dart';
import 'package:google_tasks/service_locator.dart';
import 'package:google_tasks/utils/enums/email_status.dart';
import 'package:google_tasks/utils/enums/password_status.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.carouselController});

  final CarouselController carouselController;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Timer? debounce;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
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
              CustomTextField(
                controller: emailController,
                labelText: "Адрес электронной почты",
                errorText: state.emailStatus == EmailStatus.invalid
                    ? "Invalid email address"
                    : null,
                onChanged: (value) {
                  //реализация дебаунса
                  //TODO: Записать подобное на будущее
                  if (debounce?.isActive ?? false) {
                    debounce?.cancel();
                  }
                  debounce = Timer(const Duration(milliseconds: 300), () {
                    serviceLocator<LoginCubit>().emailChanged(value);
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                  controller: passwordController,
                  obscureText: true,
                  labelText: "Пароль",
                  errorText: state.passwordStatus == PasswordStatus.invalid
                      ? "Invalid password"
                      : null,
                  onChanged: (value) {
                    if (debounce?.isActive ?? false) {
                      debounce?.cancel();
                    }
                    debounce = Timer(const Duration(milliseconds: 300), () {
                      serviceLocator<LoginCubit>().passwordChanged(value);
                    });
                  }),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () async {
                  try {
                    serviceLocator<LoginCubit>().login();
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
                    minimumSize: const MaterialStatePropertyAll(Size(300, 48)),
                    maximumSize: MaterialStatePropertyAll(
                        Size(MediaQuery.of(context).size.width * 0.9, 48))),
                child: Text("Войти",
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
                      text: "Нет аккаунта? ",
                      style: const TextStyle(color: Colors.black),
                      children: [
                    TextSpan(
                        style: const TextStyle(color: Color(0xFF50A8EB)),
                        text: "Регистрация",
                        recognizer: TapGestureRecognizer()
                          ..onTap =
                              () => widget.carouselController.animateToPage(1))
                  ]))
            ],
          );
        });
  }
}
