
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/unit/unit.dart';
import 'package:mathgasing/models/level_type/material_video.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/material_level_screen/widget/video_player_widget.dart';

class MaterialVideoWidget extends StatelessWidget {
  const MaterialVideoWidget({
    Key? key,
    required this.unit,
    required this.materi,
    required this.materialVideo,
  }) : super(key: key);

  final Materi materi;
  final Unit unit;
  final MaterialVideo materialVideo;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // Video Player
          SizedBox(height: 30,),
          SizedBox(
            width: 400.0,
            height: 300.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: VideoPlayer(materi: materi, unit: unit , materialVideo: materialVideo,), // Menggunakan materialVideo.materi untuk memperbaiki pemanggilan VideoPlayer
              ),
            ),
          ),
          //  Title
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                materialVideo.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.black,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          SizedBox(height: 10,),
          // Explanation
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                materialVideo.explanation,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.black,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ],
      ),
    );
  }
}