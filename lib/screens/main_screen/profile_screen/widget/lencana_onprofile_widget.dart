import 'package:flutter/material.dart';
import 'package:mathgasing/screens/main_screen/profile_screen/pages/lencana_page.dart';

class LenacanaonProfileWidget extends StatelessWidget {
  const LenacanaonProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(
          onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LenacanaPage()),
            );
          },
          child: Center(
            child: Container(
              // width: 350,
              height: 250,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    "Lihat Lencana",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height:10),
                  Container(
                    width: 330,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/lencana_star_icon_on_profile.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}