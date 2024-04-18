import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/user/user.dart';
import 'package:mathgasing/screens/main_screen/home_screen/widget/card_widget.dart';

class Home extends StatefulWidget {
  final String authToken;

  const Home({Key? key, required this.authToken}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
 
  Future<List<Materi>> fetchMateri() async {
    try {
      final response = await http.get(Uri.parse('https://mathgasing.cloud/api/getMateri'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'] as List<dynamic>;
        return jsonData.map((e) => Materi.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load materi from API: ${response.statusCode}');
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
        title: Text(
          'Selamat Datang',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
        leading: Container(
          margin: const EdgeInsets.all(10),
          // child: Image.asset(
          //   "assets/images/icon_profile man.png",
          //   fit: BoxFit.cover,
          // ),
        ), // Menghapus tanda koma di sini
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
                  child: Text('Error fetching materi: ${snapshot.error}'),
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
