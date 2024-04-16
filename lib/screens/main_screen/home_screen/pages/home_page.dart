import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mathgasing/models/user/user.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/screens/main_screen/home_screen/widget/card_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String _token;
  User? _loggedInUser;

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchUser();
  }

  Future<void> _loadTokenAndFetchUser() async {
    try {
      // Simpan token dari SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedToken = prefs.getString('token');

      if (storedToken != null && storedToken.isNotEmpty) {
        setState(() {
          _token = storedToken;
        });

        // Setelah token dimuat, panggil fungsi untuk mendapatkan pengguna yang login
        await fetchUser();
      } else {
        print('Stored token is empty or null.');
      }
    } catch (e) {
      print('Error loading token and fetching user: $e');
    }
  }

  Future<void> _saveToken(String token) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
    } catch (e) {
      print('Error saving token: $e');
    }
  }

  Future<User> fetchUser() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/getLoggedInUserName'),
        headers: {
          'Authorization': 'Bearer $_token', // Menggunakan token sebagai bagian dari header Authorization
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData != null && jsonData['user'] != null) {
          final user = User.fromJson(jsonData['user']);
          setState(() {
            _loggedInUser = user;
          });
          return user;
        } else {
          throw Exception('Invalid JSON data received from API');
        }
      } else {
        throw Exception('Failed to load user from API: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  Future<List<Materi>> fetchMateri() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/getMateri'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'] as List<dynamic>;
        return jsonData.map((e) => Materi.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load materi from API: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching materi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: _loggedInUser != null ? Text(_loggedInUser!.name) : Text('Loading...'),
        backgroundColor: Colors.white,
        centerTitle: false,
        leading: Container(
          margin: const EdgeInsets.all(10),
          child: _loggedInUser != null ? Image.asset(
            _getImagePath(_loggedInUser!.gender),
            fit: BoxFit.cover,
          ) : CircularProgressIndicator(),
        ),
      ),
      backgroundColor: theme.colorScheme.secondary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background_screen.png',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          FutureBuilder<List<Materi>>(
            future: fetchMateri(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final materiList = snapshot.data!;
                return ListView.builder(
                  itemCount: materiList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final materi = materiList[index];
                    return CardWidget(materi: materi);
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  String _getImagePath(String gender) {
    switch (gender.toLowerCase()) {
      case 'laki-laki':
        return "assets/images/icon_profile man.png";
      case 'perempuan':
        return "assets/images/icon_profile woman.png";
      default:
        return "assets/images/icon_profile_man.png";
    }
  }
}
