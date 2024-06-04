import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/user/user.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/after_level_screen/widget/button_to_map_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BadgeUserPage extends StatefulWidget {
  final int id_posttest;
  final Materi materi;
  final int userId;

  const BadgeUserPage({
    Key? key, 
    required this.id_posttest, 
    required this.materi, 
    required this.userId,
  }) : super(key: key);

  @override
  _BadgeUserPageState createState() => _BadgeUserPageState();
}

class _BadgeUserPageState extends State<BadgeUserPage> {
  late Future<Map<String, dynamic>> _badgeData;
  late String _token;
  late User? _loggedInUser;

  @override
  void initState() {
    super.initState();
    _badgeData = _initializeData(); // Assign the future returned by _initializeData to _badgeData
  }

  Future<Map<String, dynamic>> _initializeData() async {
    final token = await _loadTokenAndFetchUser();
    if (token != null) {
      print('id_posttest: ${widget.id_posttest}');
      print('userId: ${widget.userId}');
      return fetchBadgeData();
    } else {
      print('Token not found.');
      return Future<Map<String, dynamic>>.value({});
    }
  }

  Future<String?> _loadTokenAndFetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      _token = token;

      final user = await fetchUser(token);
      _loggedInUser = user;

      print('Logged in user: ${_loggedInUser?.id_user}');
      return token;
    }

    print('Token not found.');
    return null;
  }

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
        return User.fromJson(jsonData);
      } else {
        throw Exception('Failed to load user from API: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }


Future<Map<String, dynamic>> fetchBadgeData() async {
  final response = await http.get(Uri.parse(baseurl + 'api/badges/by-posttest/${widget.id_posttest}'));

  // Cetak header respons
  print('Response Headers: ${response.headers}');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    
    // Cetak data respons
    print('Response Data: $data');
    
    if (data['data'] != null && data['data'].isNotEmpty) {
      final badgeData = data['data'][0] as Map<String, dynamic>;
      final int badgeId = badgeData['id_bagde'];

      if (_loggedInUser != null) {
        await saveBadgeUser(_loggedInUser!.id_user, badgeId);
      } else {
        throw Exception('User not logged in');
      }
      return {
        'headers': response.headers,
        'data': badgeData
      };
    } else {
      throw Exception('Badge data is empty');
    }
  } else if (response.statusCode == 404) {
    final errorData = jsonDecode(response.body);
    print('Error: ${errorData['message']}');
    return {
      'headers': response.headers,
      'error': errorData['message']
    };
  } else {
    throw Exception('Failed to load badge data');
  }
}



  Future<void> saveBadgeUser(int userId, int badgeId) async {
    final url = Uri.parse(baseurl + 'api/addLencanaPengguna');
    final response = await http.post(
      url,
      body: {
        'id_user': userId.toString(),
        'id_bagde': badgeId.toString(),
      },
    );

    if (response.statusCode == 200) {
      print('Badge user saved successfully.');
    } else {
      throw Exception('Failed to save badge user: ${response.statusCode}');
    }
  }

@override
Widget build(BuildContext context) {
  final Materi materi = widget.materi;
  return Scaffold(
    appBar: AppBar(
      title: Text('Lencana Pemenang'),
    ),
    body: FutureBuilder(
      future: _badgeData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final data = snapshot.data as Map<String, dynamic>?;
          if (data == null || data.isEmpty || data.containsKey('error')) {
            return Center(child: Text(data != null ? data['error'] : 'No data available'));
          }

          final String? title = data['data']['title'];
          final String? explanation = data['data']['explanation'];
          final String? imageUrl = data['data']['imageUrl'];
          final headers = data['headers']; // Mengakses header respons

          if (title == null || explanation == null || imageUrl == null) {
            return Center(child: Text('Incomplete badge data'));
          }

          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    imageUrl,
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 20),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    explanation,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: BackToMap(materi: materi),
                  ),
                ],
              ),
            ),
          );
        }
      },
    ),
  );
}
}