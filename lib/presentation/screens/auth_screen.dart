import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_tasks/presentation/views/login_view.dart';
import 'package:google_tasks/presentation/views/registration_view.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  static String get route => "/auth";

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SafeArea(
            child: CarouselSlider(
              disableGesture: true,
              carouselController: carouselController,
              items: [
                LoginView(carouselController: carouselController),
                RegistrationView(carouselController: carouselController)
              ],
              options: CarouselOptions(
                  aspectRatio: 9 / 16,
                  scrollPhysics: const NeverScrollableScrollPhysics(),
                  autoPlay: false,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  viewportFraction: 1.0,
                  initialPage: 0),
            ),
          ),
        ),
      ),
    );
  }
}
