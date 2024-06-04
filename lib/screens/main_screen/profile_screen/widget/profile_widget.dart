import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mathgasing/models/user/user.dart';
import 'package:intl/intl.dart';

class ProfileData extends StatelessWidget {

  final User user;

  const ProfileData({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    DateTime joinDate = DateTime.parse(user.createdAt);
    String formattedJoinDate = DateFormat('dd MMMM yyyy').format(joinDate);
    return Container(
      child: Column(
            children: [
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.only(left: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  user.name,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 5,),
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
                              "Bergabung : ${formattedJoinDate}",
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
                              user.email,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                        ],),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.pink,
                              size: 25.0,
                              semanticLabel: 'Text to announce in accessibility modes',
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Nyawa : ${user.lives}",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 50,),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        user.gender == 'laki-laki' ? "assets/images/icon_profile man.png" :
                        user.gender == 'perempuan' ? "assets/images/icon_profile woman.png" :
                        "assets/images/icon_profile_man.png",
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