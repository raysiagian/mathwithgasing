import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/constants/constants.dart';

class MaterialVideo {
  final int id_material_video;
  final String video_Url;
  final String title;
  final String explanation;
  // final int id_unit;

  MaterialVideo ({
    required this.id_material_video,
    required this.video_Url,
    required this.title,
    required this.explanation,
    // required this.id_unit,
  });


  factory MaterialVideo.fromJson(Map<String, dynamic> json){
    return MaterialVideo(
      id_material_video: json["id_material_video"] as int, 
      video_Url: json["video_Url"] as String, 
      title: json["title"] as String, 
      explanation: json["explanation"] as String,
      // id_unit: json["id_unit"] as int,
    );
  }

  Map<String, dynamic> toJson()=> {
    'id_material_video': id_material_video,
    'video_Url': video_Url,
    'title': title,
    'explanation': explanation,
    // 'id_unit': id_unit,
  };



  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'API Token',
  };

  @override
  String toString() {
    return 'Materi{id_material_video: $id_material_video, video_Url: $video_Url, title: $title, explanation: $explanation}';
  }

}