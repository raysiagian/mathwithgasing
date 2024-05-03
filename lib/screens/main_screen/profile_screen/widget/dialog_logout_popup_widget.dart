import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/color/color.dart';
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/screens/auth/login_screen/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DialogLogout extends StatelessWidget {
  const DialogLogout({super.key});

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> _removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/images/custom_dialog_image_for_logout.png',
            fit: BoxFit.fitWidth,
          ),
          SizedBox(height: 20),
          Text(
            'Kamu Yakin Ingin\nBerhenti',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Progress pengerjaanmu akan hilang',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  try {
                    // Ambil token akses dari penyimpanan aman
                    final String? token = await _getToken();

                    if (token != null) {
                      // Kirim permintaan HTTP POST ke endpoint logout
                      final response = await http.post(
                        Uri.parse(baseurl + 'api/logout'),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                          'Authorization': 'Bearer $token', // Gunakan token akses yang diperoleh dari penyimpanan aman
                        },
                      );

                      if (response.statusCode == 200) {
                        // Hapus token dari penyimpanan lokal setelah logout berhasil
                        await _removeToken();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      } else {
                        // Tampilkan pesan kesalahan jika logout gagal
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Logout gagal'),
                          ),
                        );
                      }
                    } else {
                      // Token akses tidak ditemukan, mungkin pengguna belum login
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Anda belum login'),
                        ),
                      );
                    }
                  } catch (e) {
                    // Tangani kesalahan jika terjadi error
                    print('Error: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Terjadi kesalahan saat melakukan logout'),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 44,
                  width: 130,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    color: AppColors.logoutColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Keluar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 30),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 44,
                  width: 130,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Batal',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
