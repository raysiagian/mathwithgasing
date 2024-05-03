import 'package:flutter/material.dart';
import 'package:mathgasing/core/color/color.dart';
import 'package:mathgasing/screens/main_screen/profile_screen/pages/profile_page.dart';

class LenacanaPage extends StatefulWidget {
  const LenacanaPage({super.key});

  @override
  State<LenacanaPage> createState() => _LenacanaPageState();
}

class _LenacanaPageState extends State<LenacanaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                centerTitle: true,
        title: Text("Lencana",
         style: TextStyle(
            color: Theme.of(context).primaryColor,
        ),),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
          color: AppColors.primaryColor,),
          // onPressed: () {
          //   Navigator.pop(context);
          // }
          onPressed: () {
            Navigator.pop(context);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) =>Profile()),
            // );
          },
        ),
      ),
    );
  }
}