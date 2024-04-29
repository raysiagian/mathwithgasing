import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileData extends StatelessWidget {
  const ProfileData({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
            children: [
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.only(left: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Player Name',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.only(left: 16.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.calendar,
                              color: Colors.pink,
                              size: 25.0,
                              semanticLabel: 'Text to announce in accessibility modes',
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Bergabung 20 Maret 2024",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.mail_solid,
                              color: Colors.pink,
                              size: 25.0,
                              semanticLabel: 'Text to announce in accessibility modes',
                            ),
                            SizedBox(width: 5),
                            Text(
                              "user@gmail.com",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                        ],),
                      ],
                    ),
                    SizedBox(width: 50,),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        "assets/images/icon_profile man.png",
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ],),
              ),
            ],
          ),
    );
  }
}