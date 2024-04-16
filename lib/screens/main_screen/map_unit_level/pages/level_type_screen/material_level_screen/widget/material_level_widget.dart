import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mathgasing/models/level/level.dart';
import 'package:mathgasing/models/level_type/material_video.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/material_level_screen/widget/video_player.dart';

class MaterialVideoWidget extends StatelessWidget {
  const MaterialVideoWidget({
    Key? key,
    required this.level,
    required this.materialVideo,
    }): super(key:key);

    final Level level;
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
              child: VideoPlayer(),
            ),
          ),   
        ),
        //  Title
        Text(
          materialVideo.title,
           style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.black,
              fontFamily: GoogleFonts.roboto().fontFamily,
          ),
        ),
        SizedBox(height: 30,),
        // Explanation
         Text(
          materialVideo.explanation,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          )
        ),
      ],),
    );
  }
}
