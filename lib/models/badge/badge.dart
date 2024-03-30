import 'dart:convert';
import 'package:http/http.dart' as http;

class Badge{
  final int id_badge;
  final String image;
  final String explanation;


  Badge({
    required this.id_badge,
    required this.image,
    required this.explanation,

  });

}
