import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flashcard_quiz_app/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});
  get splash => null;
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Expanded(
            child: Center(
              child: LottieBuilder.asset("assets/lottie/lottie.json"),
            ),
          )
        ],
      ),
      nextScreen: const Homepage(),
      splashIconSize: 400,
      backgroundColor: Colors.white,
      duration: 4000,
    );
  }
}
