import 'package:flutter/material.dart';

class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({
    Key? key,
  }):super(key: key);


  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo_text_medium.png"),
            ],
          ),
        ),
        Image.asset("assets/images/splashscreenimage.png"),
      ],
    );
  }
}
