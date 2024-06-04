import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart'; // Impor VideoPlayerController
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/unit/unit.dart';
import 'package:mathgasing/models/level_type/material_video.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/material_level_screen/widget/material_video_widget.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/dialog_question_on_close_popup_widget.dart';

class MaterialLevel extends StatefulWidget {
  const MaterialLevel({
    Key? key, 
    required this.materi, 
    required this.unit,
  }): super(key:key);

  final Unit unit;
  final Materi materi;

  @override
  State<MaterialLevel> createState() => _MaterialLevelState();
}

class _MaterialLevelState extends State<MaterialLevel> {
  late Future<List<MaterialVideo>> _futureMaterialVideos;
  late VideoPlayerController _videoController; // Tambahkan VideoPlayerController

  @override
  void initState() {
    super.initState();
    _futureMaterialVideos = fetchMaterialVideo();
    _videoController = VideoPlayerController.network('video_url_here'); // Inisialisasi VideoPlayerController
  }

  Future<List<MaterialVideo>> fetchMaterialVideo() async {
    try {
      final response = await http.get(
        Uri.parse(baseurl + 'api/getMaterialVideoByUnit?id_unit=${widget.unit.id_unit}'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is List) {
          return jsonData.map((e) => MaterialVideo.fromJson(e)).toList();
        } else if (jsonData is Map<String, dynamic>) {
          if (jsonData.containsKey('data')) {
            final materialVideoData = jsonData['data'];
            if (materialVideoData is List) {
              return materialVideoData.map((e) => MaterialVideo.fromJson(e)).toList();
            } else {
              return [MaterialVideo.fromJson(materialVideoData)];
            }
          } else {
            throw Exception('Missing "data" key in API response');
          }
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to load material videos from API');
      }
    } catch (e) {
      throw Exception('Error fetching material videos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ), 
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () async {
            await _videoController.pause(); // Pause video saat tombol kembali ditekan
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return DialogQuestionOnClose(materi: widget.materi);
              },
            );
          },
        ),
        title: Text(
          'Level 2',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: FutureBuilder<List<MaterialVideo>>(
        future: _futureMaterialVideos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final materialVideos = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  for (var materialVideo in materialVideos)
                    MaterialVideoWidget(
                      unit: widget.unit, 
                      materialVideo: materialVideo,
                      materi: widget.materi,
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
