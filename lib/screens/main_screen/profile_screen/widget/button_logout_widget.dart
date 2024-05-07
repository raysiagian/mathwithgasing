import 'package:flutter/material.dart';
import 'package:mathgasing/core/color/color.dart';
import 'package:mathgasing/screens/main_screen/profile_screen/widget/dialog_logout_popup_widget.dart';

class ButtonLogout extends StatelessWidget {
  const ButtonLogout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child:              
       GestureDetector(
          onTap: () {
             showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return DialogLogout();
              },
            );
          },
          child: Container(
            height: 44,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              color: AppColors.logoutColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Keluar',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
    );
  }
}