import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:mathgasing/core/color/color.dart';
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/level_bonus/level_bonus.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/unit/unit.dart';
import 'package:mathgasing/models/unit_bonus/unit_bonus.dart';
import 'package:mathgasing/screens/main_screen/home_wrapper/pages/home_wrapper.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/unit_bonus_widget.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/unit_widget.dart';

class MapUnitLevel extends StatelessWidget {
  const MapUnitLevel({Key? key, required this.materi}) : super(key: key);

  final Materi materi;

   Future<List<Unit>> fetchUnit() async {
    try {
      final response = await http.get(
        Uri.parse(baseurl + 'api/getUnitByMateri?id_materi=${materi.id_materi}'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is List) {
          return jsonData.map((e) => Unit.fromJson(e)).toList();
        } else if (jsonData is Map<String, dynamic>) {
          if (jsonData.containsKey('data')) {
            final unitData = jsonData['data'];
            if (unitData is List) {
              return unitData.map((e) => Unit.fromJson(e)).toList();
            } else {
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

  Future<List<UnitBonus>> fetchUnitBonus() async {
    try {
      final response = await http.get(
        // Uri.parse(baseurl + 'api/unitbonus/getByMateri?id_materi=${materi.id_materi}'),
        // Uri.parse(baseurl + 'api/unitbonus/getByMateri?id_materi=${materi.id_materi}'),
        Uri.parse(baseurl + 'api/unitbonus/getByMateri/${materi.id_materi}'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is List) {
          return jsonData.map((e) => UnitBonus.fromJson(e)).toList();
        } else if (jsonData is Map<String, dynamic>) {
          if (jsonData.containsKey('data')) {
            final unitBonusData = jsonData['data'];
            if (unitBonusData is List) {
              return unitBonusData.map((e) => UnitBonus.fromJson(e)).toList();
            } else {
              return [UnitBonus.fromJson(unitBonusData)];
            }
          } else {
            throw Exception('Missing "data" key in API response');
          }
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to load unit bonuses from API');
      }
    } catch (e) {
      throw Exception('Error fetching unit bonuses: $e');
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          materi.title,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryColor,
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeWrapper()),
              (route) => false,
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                 '${materi.imageBackground}',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<List<Unit>>(
                  future: fetchUnit(), // Memanggil fungsi untuk mengambil unit dari API
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(), // Tampilkan indikator loading
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text('No units available'),
                      );
                    } else {
                      // Jika data unit tersedia, tampilkan UnitWidget untuk setiap unit
                      return Column(
                        children: snapshot.data!.map((unit) {
                          return UnitWidget(
                            unit: unit,
                            materi: materi,
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
                SizedBox(height: 10,),
            FutureBuilder<List<UnitBonus>>(
              future: fetchUnitBonus(), // Memanggil fungsi untuk mengambil unit bonus dari API
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(), // Tampilkan indikator loading
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No unit bonuses available'),
                  );
                } else {
                  return Column(
                    children: snapshot.data!.map((unitBonus) {
                      return UnitBonusWidget(
                        unitBonus: unitBonus,
                        materi: materi,
                      );
                    }).toList(),
                  );
                }
              },
            ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}