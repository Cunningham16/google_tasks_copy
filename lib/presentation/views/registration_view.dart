import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_tasks/presentation/bloc/register_cubit/register_cubit.dart';
import 'package:google_tasks/presentation/components/custom_textfield.dart';
import 'package:google_tasks/presentation/screens/screens.dart';
import 'package:google_tasks/utils/enums/email_status.dart';
import 'package:google_tasks/utils/enums/password_status.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key, required this.carouselController});

  final CarouselController carouselController;

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  Timer? debounce;

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
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
                labelText: "Имя",
                onChanged: (value) =>
                    context.read<RegisterCubit>().nameChanged(value),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                  labelText: "Адрес электронной почты",
                  errorText: state.emailStatus == EmailStatus.invalid
                      ? "Invalid email address"
                      : null,
                  onChanged: (value) {
                    if (debounce?.isActive ?? false) {
                      debounce?.cancel();
                    }
                    debounce = Timer(const Duration(milliseconds: 300), () {
                      context.read<RegisterCubit>().emailChanged(value);
                    });
                  }),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
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
                      context.read<RegisterCubit>().passwordChanged(value);
                    });
                  }),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  try {
                    context.read<RegisterCubit>().register();
                    context.go(HomeScreen.route);
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (context) => Text(e.toString()),
                    );
                  }
                },
                style: ButtonStyle(
                    shape: const MaterialStatePropertyAll(LinearBorder()),
                    backgroundColor:
                        const MaterialStatePropertyAll(Color(0xFF50A8EB)),
                    minimumSize: const MaterialStatePropertyAll(Size(300, 48)),
                    maximumSize: MaterialStatePropertyAll(
                        Size(MediaQuery.of(context).size.width * 0.9, 48))),
                child: Text("Зарегистрироваться",
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
                      text: "Есть аккаунт? ",
                      style: const TextStyle(color: Colors.black),
                      children: [
                    TextSpan(
                      style: const TextStyle(color: Color(0xFF50A8EB)),
                      text: "Войти",
                      recognizer: TapGestureRecognizer()
                        ..onTap =
                            () => widget.carouselController.animateToPage(0),
                    )
                  ]))
            ],
          );
        });
  }
}
