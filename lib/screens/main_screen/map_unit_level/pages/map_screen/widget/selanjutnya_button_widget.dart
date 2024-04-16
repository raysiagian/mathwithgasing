import 'package:flutter/material.dart';
import 'package:mathgasing/core/color/color.dart';


class SelanjutnyaButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SelanjutnyaButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 44,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
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
