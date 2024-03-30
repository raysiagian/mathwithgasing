import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/unit/unit.dart';

class UnitWidget extends StatelessWidget {
  const UnitWidget({
    Key? key,
    required this.unit,
    required this.materi,
  }) : super(key: key);

  final Unit unit;
  final Materi materi;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Container(
            padding: const EdgeInsets.only(left: 10.0, top: 30),
            height: 170,
            color: Color.fromRGBO(0, 0, 0, 0.4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unit.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  unit.explanation,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
