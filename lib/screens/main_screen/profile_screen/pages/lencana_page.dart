import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/color/color.dart';
import 'package:mathgasing/core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LenacanaPage extends StatefulWidget {
  final int userId;

  const LenacanaPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<LenacanaPage> createState() => _LenacanaPageState();
}

class _LenacanaPageState extends State<LenacanaPage> {
  late int _loggedInUserId;
  List<Map<String, String>> lencanaList = [];
  late String _token;
  bool isLoading = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchUser();
    fetchLencanaData();
  }

  Future<void> _loadTokenAndFetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? userId = prefs.getInt('userId'); // Ambil ID pengguna dari SharedPreferences

    if (token != null && userId != null) {
      setState(() {
        _token = token;
        _loggedInUserId = userId; // Simpan ID pengguna yang sedang login
      });
      await fetchLencanaData(); // Ensure this is awaited
    }
  }

Future<void> fetchLencanaData() async {
  setState(() {
    isLoading = true;
  });

  try {
    final response = await http.get(
      Uri.parse(baseurl + 'api/lencana-pengguna/${widget.userId}'),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body)['data'];
      print('Lencana data: $responseData');

      if (responseData.isNotEmpty) {
        await fetchBadgeInfo(responseData);
      } else {
        throw Exception('Response data is empty');
      }
    } else {
      throw Exception('Ups, kamu belum memiliki lencana');
    }
  } catch (e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ups, kamu belum memiliki lencana'),
        content: Text('ayo kerjakan semua levelnya dan raih lencana.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}


  Future<void> fetchBadgeInfo(List<dynamic> lencanaData) async {
    Set<int> addedBadgeIds = {};

    final badgeInfoResponse = await http.get(
      Uri.parse(baseurl + 'api/badges'),
    );
    
    print('Badge Info Response status: ${badgeInfoResponse.statusCode}');
    print('Badge Info Response body: ${badgeInfoResponse.body}');

    if (badgeInfoResponse.statusCode == 200) {
      final List<dynamic> badges = jsonDecode(badgeInfoResponse.body)['data'];

      for (var lencana in lencanaData) {
        final idBadge = int.parse(lencana['id_bagde']);
        if (!addedBadgeIds.contains(idBadge)) { 
          final badgeInfo = badges.firstWhere((badge) => badge['id_bagde'] == idBadge, orElse: () => null);

          if (badgeInfo != null) {
            final badgeTitle = badgeInfo['title'];
            final badgeImage = badgeInfo['imageUrl'];
            final badgeExplanation = badgeInfo['explanation'];

            print('Badge info: $badgeInfo');

            lencanaList.add({
              'title': badgeTitle,
              'imageUrl': badgeImage,
              'explanation': badgeExplanation,
            });
            addedBadgeIds.add(idBadge);
          } else {
            print('Data Lencana Tidak Ditemukan: $idBadge');
          }
        }
      }
    } else {
      throw Exception('Gagal Menampilkan Data Lencana: ${badgeInfoResponse.reasonPhrase}');
    }
    print('Lencana list: $lencanaList');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Lencana",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(child: Text(error))
              : lencanaList.isEmpty
                  ? Center(child: Text('Tidak ada lencana yang ditemukan'))
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: lencanaList.length,
                      itemBuilder: (context, index) {
                        return _buildBadgeTile(lencanaList[index]);
                      },
                    ),
    );
  }

Widget _buildBadgeTile(Map<String, String> badgeInfo) {
  return Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                badgeInfo['imageUrl'] ?? '',
                height: 100,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            badgeInfo['title'] ?? '',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.0),
          if (badgeInfo['explanation'] != null)
            Text(
              badgeInfo['explanation']!,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
    ),
  );
}

}
