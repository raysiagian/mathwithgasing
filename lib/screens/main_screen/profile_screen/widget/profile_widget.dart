import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mathgasing/models/user/user.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:mathgasing/screens/main_screen/profile_screen/widget/dialog_edit_name.dart';

class ProfileData extends StatefulWidget {
  final User user;

  const ProfileData({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _ProfileDataState createState() => _ProfileDataState();
}

class _ProfileDataState extends State<ProfileData> {
  late TextEditingController _nameController;
  late GlobalKey<FormState> _formKey;
  late DateTime joinDate;
  late String formattedJoinDate;

  @override
  void initState() {
    super.initState();
     _nameController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    joinDate = DateTime.parse(widget.user.createdAt);
    formattedJoinDate = DateFormat('dd MMMM yyyy').format(joinDate);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // void _showEditDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return DialogEditName(
  //         user: widget.user,          
  //       );
  //     },
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 15),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.user.name,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              // IconButton(
              //   icon: Icon(Icons.edit),
              //   onPressed: _showEditDialog,
              // ),
            ],
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
                          "Nyawa : $formattedJoinDate",
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
                          widget.user.email,
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
                          "Nyawa : ${widget.user.lives}",
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
                    widget.user.gender == 'laki-laki' ? "assets/images/icon_profile man.png" :
                    widget.user.gender == 'perempuan' ? "assets/images/icon_profile woman.png" :
                    "assets/images/icon_profile_man.png",
                    width: 100,
                    height: 100,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
