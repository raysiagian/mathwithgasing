import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mathgasing/models/user/user.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/screens/main_screen/home_screen/widget/card_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  
  static Future<List<User>> fetchUser() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/getUser'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData != null) {
          if (jsonData is List) {
            return jsonData.map((e) => User.fromJson(e)).toList();
          } else if (jsonData is Map<String, dynamic>) {
            if (jsonData.containsKey('data')) {
              final userData = jsonData['data'];
              if (userData != null) {
                if (userData is List) {
                  return userData.map((e) => User.fromJson(e)).toList();
                } else {
                  return [User.fromJson(userData)];
                }
              } else {
                throw Exception('Null user data received from API');
              }
            } else {
              throw Exception('Missing "data" key in API response');
            }
          } else {
            throw Exception('Unexpected data format');
          }
        } else {
          throw Exception('Null JSON data received from API');
        }
      } else {
        throw Exception('Failed to load users from API: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }


  
  Future<List<Materi>> fetchMateri() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/getMateri'));

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
        title: FutureBuilder<List<User>>(
          future: fetchUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...'); // Placeholder text while loading
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final user = snapshot.data!.first; // Assuming only one user is fetched
              return Text(user.name,
                style: TextStyle(
              color: Theme.of(context).primaryColor,
          ),);
            }
          },
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
        leading: Container(
          margin: const EdgeInsets.all(10),
          // child: Image.asset(
          //   "assets/images/icon_profile man.png",
          //   fit: BoxFit.cover,
          // ),
          child: FutureBuilder<List<User>>(
            future: fetchUser(),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return CircularProgressIndicator();
              }else if (snapshot.hasError){
                return Text('Error: $snapshot.error');
              }else{
                final user = snapshot.data!.first;
                String gender = user.gender.toLowerCase(); // Menggunakan variabel 'user' bukan 'User'
                String imagePath;
                if (gender == 'laki-laki'){
                  imagePath = "assets/images/icon_profile man.png";
                }else if (gender == 'perempuan'){
                  imagePath = "assets/images/icon_profile woman.png";
                }else{
                  // Default image or handle other cases
                  imagePath = "assets/images/icon_profile_man.png";
                }
                return Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                );
              }
            },
          ),

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
}
