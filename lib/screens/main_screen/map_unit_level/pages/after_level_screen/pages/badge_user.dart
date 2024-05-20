import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/level_type/posttest.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/user/user.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/after_level_screen/widget/button_to_map_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BadgeUserPage extends StatefulWidget {
  final int id_posttest;
  final Materi materi;
  final int userId; // Tambahkan userId di sini

  const BadgeUserPage({Key? key, required this.id_posttest, required this.materi, required this.userId}) : super(key: key);

  @override
  _BadgeUserPageState createState() => _BadgeUserPageState();
}

class _BadgeUserPageState extends State<BadgeUserPage> {
  late Future<Map<String, dynamic>> _badgeData = Future<Map<String, dynamic>>.value({});
  late String _token;
  late User? _loggedInUser;

  @override
void initState() {
  super.initState();
  _initializeData();
}

Future<void> _initializeData() async {
  final token = await _loadTokenAndFetchUser();
  if (token != null) {
    print('id_posttest: ${widget.id_posttest}');
    print('userId: ${widget.userId}');
    _badgeData = fetchBadgeData();
  } else {
    // Handle case when token is not found
    print('Token not found.');
    setState(() {
      _badgeData = Future<Map<String, dynamic>>.value(null);
    });
  }
}



  Future<String?> _loadTokenAndFetchUser() async {
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

    // Debugging: Print id_user yang sedang login
    print('Logged in user: ${_loggedInUser?.id_user}');

    return token; // Return the token value
  }

  // Debugging: Print pesan jika token tidak ditemukan
  print('Token not found.');

  return null; // Return null if token is not found
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
    print('_loggedInUser: $_loggedInUser'); 
  final response = await http.get(Uri.parse(baseurl + 'api/badges/by-posttest/${widget.id_posttest}'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print('Badge data: $data'); // Debugging
    if (data['data'] != null && data['data'].isNotEmpty) {
      final badgeData = data['data'][0] as Map<String, dynamic>;
      print('Badge data: $badgeData'); // Debugging
      final int badgeId = badgeData['id_bagde']; // Ubah kunci menjadi id_badge

      print('badgeId: $badgeId'); // Debugging

      // Simpan lencana pengguna jika userId tidak null
     if (_loggedInUser != null) {
      await saveBadgeUser(_loggedInUser!.id_user, badgeId);
    } else {
      throw Exception('User not logged in');
    }


      return data;
    } else {
      throw Exception('Badge data is empty');
    }
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
        'id_badge': badgeId.toString(),
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
        title: Text('Badge User Page'),
      ),
      body: FutureBuilder(
        future: _badgeData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Tampilkan data badge setelah berhasil dimuat
            final data = snapshot.data as Map<String, dynamic>?; // Tambahkan ? untuk menandakan nullable
            if (data == null || data['data'] == null || data['data'].isEmpty) {
              return Center(child: Text('No data available'));
            }
            final badgeData = data['data'][0] as Map<String, dynamic>;
            final String? title = badgeData['title'];
            final String? explanation = badgeData['explanation'];

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.network(
                  //   baseurl + 'storage/' + 'public/images/7xIL3fVK9meBGZDCRmx07v8meI0A2bkriX811oST.png',
                  //   width: 100,
                  //   height: 100,
                  //   // Sesuaikan ukuran dan properti lainnya sesuai kebutuhan
                  // ),
                  SizedBox(height: 20),
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    explanation!,
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
            );
          }
        },
      ),
    );
  }
}