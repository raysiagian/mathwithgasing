import 'package:flutter/material.dart';
import 'package:mathgasing/core/color/color.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/pages/map_unit_level.dart';

class DialogLivesRunOut extends StatelessWidget {
  const DialogLivesRunOut({super.key, required this.materi});

  final Materi materi;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/images/custom_dialog_image_for_close_question.png',
            fit: BoxFit.fitWidth,
          ),
          SizedBox(height: 20),
          Text(
            'Kamu Kehabisan\nNyawa',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) {
                  return MapUnitLevel(materi: materi,);
                }),
                (route) => false,
              );
            },
            child: Container(
              height: 44,
              width: 130,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primaryColor,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Keluar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
