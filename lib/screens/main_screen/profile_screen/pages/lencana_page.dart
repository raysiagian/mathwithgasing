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

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body)['data'];

        // Periksa apakah respons merupakan List<dynamic>
        if (responseData.isNotEmpty) {
          // Ambil informasi badge berdasarkan id_badge
          await fetchBadgeInfo(responseData);
        } else {
          throw Exception('Response data is empty');
        }
      } else {
        throw Exception('Failed to load lencana: ${response.reasonPhrase}');
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching lencana: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchBadgeInfo(List<dynamic> lencanaData) async {
  Set<int> addedBadgeIds = {}; // Buat set untuk menyimpan BadgeId yang sudah ditambahkan

  for (var lencana in lencanaData) {
    final idBadge = lencana['id_badge'];
    if (!addedBadgeIds.contains(idBadge)) { // Periksa apakah BadgeId sudah ditambahkan sebelumnya
      final badgeInfoResponse = await http.get(
        Uri.parse(baseurl + 'api/badges/$idBadge'),
      );
      print('Fetching badge info for id_badge: $idBadge');

      if (badgeInfoResponse.statusCode == 200) {
        final badgeInfo = jsonDecode(badgeInfoResponse.body)['data'];
        final badgeTitle = badgeInfo['title'];
        final badgeImage = badgeInfo['imageUrl'];
        final badgeExplanation = badgeInfo['explanation'];

        print('Badge title: $badgeTitle');
        print('Badge image URL: $badgeImage');
        print('Badge explanation: $badgeExplanation');

        lencanaList.add({
          'title': badgeTitle,
          'image': badgeImage,
          'explanation': badgeExplanation,
        });
        addedBadgeIds.add(idBadge); // Tambahkan BadgeId ke dalam set
      } else {
        throw Exception('Failed to fetch badge info: ${badgeInfoResponse.reasonPhrase}');
      }
    }
  }
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
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Ubah sesuai kebutuhan Anda
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
   return GridTile(
  child: Container(
    width: 350,
    height: 350,
    margin: EdgeInsets.all(8.0),
    padding: EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: Colors.blue.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
    ),
   child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(8.0),
          //   child: Image.network(
          //     badgeInfo['imageUrl'] ?? '',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          // SizedBox(height: 8.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  badgeInfo['title'] ?? '',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                SizedBox(height: 4.0),
                if (badgeInfo['explanation'] != null)
                  Text(
                    badgeInfo['explanation']!,
                    style: TextStyle(color: Colors.white),
                  ),
              ],
            ),
          ),
        ],
      ),
  ),
);

  }
}