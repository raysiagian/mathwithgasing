import 'package:flutter/material.dart';
import 'package:mathgasing/core/color/color.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/pages/map_unit_level.dart';

class BackToMap extends StatelessWidget {
  const BackToMap({super.key, required this.materi});

  final Materi materi;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
