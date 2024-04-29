import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mathgasing/screens/auth/login_screen/widget/button_logout_widget.dart';
import 'package:mathgasing/screens/main_screen/profile_screen/widget/dialog_logout_popup_widget.dart';
import 'package:mathgasing/screens/main_screen/profile_screen/widget/profile_widget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profil",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
         Column(children: [
          ProfileData(),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ButtonLogout(),
          ),
         ],),
        ],
      ),
    );
  }
}