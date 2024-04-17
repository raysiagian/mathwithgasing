import 'dart:convert';
import 'package:http/http.dart' as http;

class MaterialVideo {
  final int id_material_video;
  final String video_Url;
  final String title;
  final String explanation;
  final int id_level;

  MaterialVideo ({
    required this.id_material_video,
    required this.video_Url,
    required this.title,
    required this.explanation,
    required this.id_level,
  });

  Future<List<MaterialVideo>> getMaterialVideo() async {
    try {
      var url = Uri.parse("http://10.0.2.2:8000/api/getMaterialVideo");
      final response = await http.get(url, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => MaterialVideo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load units from API');
      }
    } catch (e) {
      throw Exception('Error fetching material videos: $e');
    }
  }

  factory MaterialVideo.fromJson(Map<String, dynamic> json){
    return MaterialVideo(
      id_material_video: json["id_material_video"] as int, 
      video_Url: json["video_Url"] as String, 
      title: json["title"] as String, 
      explanation: json["explanation"] as String,
      id_level: json["id_level"]as int,
    );
  }


  Map<String, dynamic> toJson()=> {
    'id_material_video': id_material_video,
    'video_Url': video_Url,
    'title': title,
    'explanation': explanation,
    'id_level': id_level,
  };



  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'API Token',
  };

  @override
  String toString() {
    return 'Materi{id_material_video: $id_material_video, video_Url: $video_Url, title: $title, explanation: $explanation, id_level: $id_level}';
  }

}
