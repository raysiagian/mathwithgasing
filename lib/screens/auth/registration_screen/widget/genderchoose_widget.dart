import 'package:flutter/material.dart';
import 'package:mathgasing/screens/auth/registration_screen/models/gender_model.dart';
import 'package:mathgasing/core/color/color.dart';


class GenderWidget extends StatelessWidget {
  const GenderWidget({
    super.key,
    required this.gender,
    required this.selectedGender,
  });

  final Gender gender;
  final String selectedGender;

  @override
  Widget build(BuildContext context){
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: selectedGender == gender.explanation ?
            AppColors.primaryColor :
            Colors.white,
        )
      ),
      padding: const EdgeInsets.all(50.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            gender.imageGender,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Text(
            gender.explanation,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            )
          ),
        ],
      ),
    );
  }

}