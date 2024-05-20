import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/color/color.dart';
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/level_type/material_video.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/unit/unit.dart';
import 'package:mathgasing/models/user/user.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/pages/map_unit_level.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackToMapVideo extends StatelessWidget {
  const BackToMapVideo({
    Key? key,
    required this.unit,
    required this.materi,
    required this.materialVideo,
  }) : super(key: key);

  final Materi materi;
  final Unit unit;
  final MaterialVideo materialVideo;

  Future<void> _completeVideo(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token != null) {
        // Load user using token
        User? loggedInUser = await fetchUser(token);
        if (loggedInUser != null) {
          var url = Uri.parse(
              baseurl + 'api/watch-material-video/${materialVideo.id_material_video}/mark-completed');
          var response = await http.put(
            url,
            headers: {'Authorization': 'Bearer $token'},
            body: {'id_unit': unit.id_unit.toString(), 'id_material_video': materialVideo.id_material_video.toString(), 'is_completed': '1'},
          );

          if (response.statusCode == 200) {
            // Handle response jika sukses
            print('Video completed successfully');
          } else {
            // Handle response jika gagal
            print('Failed to complete video');
          }
        }
      }
    } catch (e) {
      // Handle error jika terjadi
      print('Error: $e');
    }
  }

  Future<User?> fetchUser(String token) async {
    try {
      final response = await http.get(
        Uri.parse(baseurl + 'api/user'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return User.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to load user from API: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _completeVideo(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) {
            return MapUnitLevel(materi:materi);
          }),
          (route) => false,
        );
      },
      child: Container(
        height: 44,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: AppColors.greenColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Kembali Ke Map',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
