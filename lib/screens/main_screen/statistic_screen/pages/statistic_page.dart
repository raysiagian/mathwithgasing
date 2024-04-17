import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mathgasing/models/materi/materi.dart';
import 'dart:convert';

import 'package:mathgasing/screens/main_screen/statistic_screen/widget/statistic_widget.dart';

class Statistic extends StatefulWidget {
  const Statistic({Key? key}) : super(key: key);

  @override
  State<Statistic> createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
  late Future<List<Materi>> futureMateri;

  @override
  void initState() {
    super.initState();
    futureMateri = fetchMateri();
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Statistik",
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
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background_screen.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          FutureBuilder<List<Materi>>(
            future: futureMateri,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final materiList = snapshot.data!;
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: constraints.maxHeight * .6,
                            child: GridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 2,
                              children: materiList.map((materi) => StatisticWidget(materi: materi)).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
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