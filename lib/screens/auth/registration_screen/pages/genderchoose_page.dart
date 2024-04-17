//genderchoose_page
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mathgasing/screens/auth/login_screen/pages/login_page.dart';
import 'package:mathgasing/screens/auth/registration_screen/models/gender_model.dart';
import 'package:mathgasing/screens/auth/registration_screen/widget/genderchoose_widget.dart';


class GenderChoose extends StatefulWidget {
  const GenderChoose({
    Key? key,
    required this.name,
    required this.email,
    required this.password,
  }) : super(key: key);

  final String name;
  final String email;
  final String password;

  @override
  State<GenderChoose> createState() => _GenderChooseState();
}

class _GenderChooseState extends State<GenderChoose> {
  final List<Gender> listGender = Gender.listGender;
  String selectedGender = 'perempuan';

  Future<void> _registerUser() async {
    try {
      // Kirim data registrasi ke backend
      var response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/register'), // Ganti dengan URL API registrasi Anda
        body: {
          'name': widget.name,
          'email': widget.email,
          'password': widget.password,
          'gender': selectedGender,
        },
      );

      if (response.statusCode == 200) {
        // Registrasi berhasil, arahkan pengguna ke halaman beranda
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        // Gagal mendaftar, tampilkan pesan kesalahan
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.body}'),
        ));
      }
    } catch (e) {
      // Error lainnya, tangani sesuai kebutuhan Anda
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Terjadi kesalahan. Silakan coba lagi nanti.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 50),
            Text(
              "Pilih Jenis Kelamin",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: List.generate(listGender.length, (index) {
                final gender = listGender[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGender = gender.code;
                    });
                  },
                  child: GenderWidget(
                    gender: gender,
                    selectedGender: selectedGender,
                  ),
                );
              }),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(children: [
              GestureDetector(
              onTap: _registerUser, // Panggil fungsi registrasi saat tombol ditekan
              child: Container(
                height: 44,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Daftar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
             SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    // MaterialPageRoute(builder: (context) => Register()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: SizedBox(
                  height: 44,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Kembali',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              ],),
              
            )
          ],
        ),
      ),
    );
  }
}
