import 'dart:convert';
import 'package:http/http.dart' as http;

class MaterialVideo {
  final int id_material_video;
  final String videoUrl;
  final String title;
  final String explanation;

  MaterialVideo ({
    required this.id_material_video,
    required this.videoUrl,
    required this.title,
    required this.explanation,
  });

}
