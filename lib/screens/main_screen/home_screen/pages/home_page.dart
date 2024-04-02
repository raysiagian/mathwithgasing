import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/screens/main_screen/home_screen/widget/card_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String _userName;

  // Future<List<Materi>> fetchMateri() async {
  //   try {
  //     final response =
  //         await http.get(Uri.parse('http://10.0.2.2:8000/api/getMateri'));

  //     if (response.statusCode == 200) {
  //       final jsonData = jsonDecode(response.body)['data'] as List<dynamic>;
  //       return jsonData.map((e) => Materi.fromJson(e)).toList();
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     return [];
  //   }
  // }

  Future<List<Materi>> fetchMateri() async {
    try {
      var exampleResponse = [
        {
          "id_materi": 1,
          "title": "Title 1",
          "imageCard": "image_card_1.png",
          "imageBackground": "image_background_1.png"
        },
        {
          "id_materi": 2,
          "title": "Title 2",
          "imageCard": "image_card_2.png",
          "imageBackground": "image_background_2.png"
        },
        {
          "id_materi": 3,
          "title": "Title 3",
          "imageCard": "image_card_3.png",
          "imageBackground": "image_background_3.png"
        }
      ];

      List<Materi> data = exampleResponse.map((e) => Materi.fromJson(e)).toList();
      return data;

    } on SocketException catch (e){
      throw Exception(e.message);
    } catch (e) {
      print(e.toString());
      return [];
    }
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Selamat Datang"),
        centerTitle: false,
        leading: Container(
          margin: EdgeInsets.all(10),
          child: Image.asset(
            "assets/images/icon_profile man.png",
            fit: BoxFit.cover,
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
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final materi = snapshot.data![index];
                      return CardWidget(materi: materi);
                    },
                  );
                } else {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
