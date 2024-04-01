import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/unit/unit.dart';
import 'package:mathgasing/screens/main_screen/home_wrapper/pages/home_wrapper.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/unit_widget.dart';

class MapUnitLevel extends StatelessWidget {
  const MapUnitLevel({Key? key, required this.materi}) : super(key: key);

  final Materi materi;

  // Future<List<Unit>> fetchUnit() async {
  //   try {
  //     final response =
  //         await http.get(Uri.parse('http://10.0.2.2:8000/api/getUnit'));

  //     if (response.statusCode == 200) {
  //       final jsonData = jsonDecode(response.body) as List<dynamic>;
  //       print(jsonData);
  //       return jsonData.map((e) => Unit.fromJson(e)).toList();
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     return [];
  //   }
  // }

  Future<List<Unit>> fetchUnit() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/getUnit'), // Updated endpoint
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is List) {
          // If jsonData is a list, parse it as a list of units
          return jsonData.map((e) => Unit.fromJson(e)).toList();
        } else if (jsonData is Map<String, dynamic>) {
          // If jsonData is a map, check if it contains a 'data' key
          if (jsonData.containsKey('data')) {
            final unitData = jsonData['data'];
            if (unitData is List) {
              // If 'data' is a list, parse it as a list of units
              return unitData.map((e) => Unit.fromJson(e)).toList();
            } else {
              // If 'data' is a single object, parse it as a single unit
              return [Unit.fromJson(unitData)];
            }
          } else {
            throw Exception('Missing "data" key in API response');
          }
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to load units from API');
      }
    } catch (e) {
      throw Exception('Error fetching units: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(materi.title),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }
          // onPressed: () {
          //   Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(builder: (context) => HomeWrapper()),
          //     (route) => false,
          //   );
          // },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'http://10.0.2.2:8000/storage/' +
                materi.imageBackground.replaceFirst('public/', ''),
            height: 150,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Column(
            children: [
              FutureBuilder<List<Unit>>(
                future: fetchUnit(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(), // or any loading indicator
                    );
                  }else{
                    if (snapshot.hasData && snapshot.data!.isNotEmpty){
                      return ListView.builder(
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          final unit = snapshot.data![index];
                          return UnitWidget(unit: unit, materi: materi);
                        },
                      );
                    } else{
                    print('data kosong');
                      return Center(
                        child:  Text('Error: ${snapshot.error}'),
                      );
                    }
                  }
                },
              ),
              // Future Builder Level Pretest
              // Future Builder Level Material
              // Future Builder Level Posttest
            ],
          )
        ], 
      ),
    );
  }
}
