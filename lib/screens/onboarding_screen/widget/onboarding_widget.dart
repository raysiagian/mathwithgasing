import 'package:flutter/material.dart';
import 'package:mathgasing/screens/onboarding_screen/models/onboarding_model.dart';


class OnboardingWidget extends StatelessWidget {
  const OnboardingWidget({
    Key? key,
    required this.onboarding,
  }) : super(key: key);

  final OnboardingModel onboarding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center( // Tambahkan Center di sini
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                onboarding.imageOnboarding,
              ),
              SizedBox(height: 30),
              Text(
                onboarding.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                onboarding.explanation,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
