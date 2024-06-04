import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/user/user.dart';
import 'package:http/http.dart' as http;
import 'package:mathgasing/screens/main_screen/profile_screen/widget/button_logout_widget.dart';
import 'package:mathgasing/screens/main_screen/profile_screen/widget/lencana_onprofile_widget.dart';
import 'package:mathgasing/screens/main_screen/profile_screen/widget/profile_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  late String _token;
  User? _loggedInUser;

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchUser();
  }

  _loadTokenAndFetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        _token = token;
      });

      // Load user using token
      final user = await fetchUser(token);
      setState(() {
        _loggedInUser = user;
      });
    }
  }

  // Future<User> fetchUser(String token) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse(baseurl + 'api/user'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final jsonData = jsonDecode(response.body);
  //       return User.fromJson(jsonData);
  //     } else {
  //       throw Exception('Failed to load user from API: ${response.reasonPhrase}');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching user: $e');
  //   }
  // }

    Future<User> fetchUser(String token) async {
  try {
    final response = await http.get(
      Uri.parse(baseurl + 'api/user'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      // Debugging output
      print('API Response: $jsonData');

      return User.fromJson(jsonData);
    } else {
      throw Exception('Failed to load user from API: ${response.reasonPhrase}');
    }
  } catch (e) {
    throw Exception('Error fetching user: $e');
  }
}

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
            if (_loggedInUser != null)
              ProfileData(user: _loggedInUser!),
            SizedBox(height: 15,),
            Container(
              padding: EdgeInsets.all(15),
              child: LenacanaonProfileWidget(userId: _loggedInUser?.id_user ?? 0,),
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ButtonLogout(),
            ),
          ]),
        ],
      ),
    );
  }
}