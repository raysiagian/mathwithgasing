import 'package:flutter/material.dart';
import 'package:mathgasing/screens/auth/registration_screen/widget/registration_widget.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        child: Column(children: <Widget>[
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
          Expanded(child: 
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: RegisterWidget(name:'',email: '', password: '',),
              ),
            )
          ),
        ],),
      ),
    );
  }
}