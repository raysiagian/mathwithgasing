import 'package:flutter/material.dart';


class SelanjutnyaOnboardingButton extends StatelessWidget {
  const SelanjutnyaOnboardingButton({
    Key? key,
    required this.onboardingSelanjutnya,
  }) : super(key: key);

  final VoidCallback onboardingSelanjutnya;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onboardingSelanjutnya,
      child: Container(
        height: 44,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Selanjutnya',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
