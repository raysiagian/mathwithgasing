import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mathgasing/screens/auth/login_screen/widget/forget_password_widget.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
     body: Container(
       child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ForgetPasswordWidget(),
      ),
     ),
    );
  }
}