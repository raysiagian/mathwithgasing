import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathgasing/models/level/level.dart';
import 'package:mathgasing/models/level_type/material_video.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/material_level_page.dart/widget/material_video_widget.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/dialog_question_on_close_popup_widget.dart';

class MaterialLevel extends StatefulWidget {
  const MaterialLevel({
    Key? key, 
    required this.materi, 
    required this.level,
  }): super(key:key);

  final Level level;
  final Materi materi;

  @override
  State<MaterialLevel> createState() => _MaterialLevelState();
}

class _MaterialLevelState extends State<MaterialLevel> {
  late Future<List<MaterialVideo>> _futureMaterialVideos;

  @override
  void initState() {
    super.initState();
    _futureMaterialVideos = fetchMaterialVideo();
  }

  Future<List<MaterialVideo>> fetchMaterialVideo() async {
    try {
      final response = await http.get(
        Uri.parse('https://mathgasing.cloud/api/getMaterialVideo'),
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
          onPressed: () {
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
          'Level ${widget.level.level_number}',
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
                      level: widget.level, 
                      materialVideo: materialVideo,
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
