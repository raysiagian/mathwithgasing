// login_screen.dart

import 'package:flutter/material.dart';
import 'package:mathgasing/screens/auth/login_screen/widget/login_widget.dart';
import 'package:mathgasing/screens/main_screen/home_wrapper/pages/home_wrapper.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void _handleLoginSuccess(String authToken) {
    // Handle successful login here, e.g., navigate to the home screen
    // You can also store the authToken in a state management solution like Provider or Riverpod
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/logo_text_small.png"),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Image.asset("assets/images/login_images.png"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: LoginWidget(
                    onLoginSuccess: _handleLoginSuccess,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
