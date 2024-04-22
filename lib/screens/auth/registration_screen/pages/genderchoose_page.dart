import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/screens/auth/login_screen/pages/login_page.dart';
import 'package:mathgasing/screens/auth/registration_screen/models/gender_model.dart';
import 'package:mathgasing/screens/auth/registration_screen/widget/genderchoose_widget.dart';
import 'package:mathgasing/core/color/color.dart';


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
        Uri.parse(baseurl + 'api/register'), // Ganti dengan URL API registrasi Anda
        body: {
          'name': widget.name,
          'email': widget.email,
          'password': widget.password,
          'gender': selectedGender,
        },
      );

      if (response.statusCode == 201) {
        // Registrasi berhasil, arahkan pengguna ke halaman beranda
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Berhasil Mendaftar'),
        ));
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
                      selectedGender = gender.explanation;
                    });
                  },
                  child: GenderWidget(
                    gender: gender,
                    selectedGender: selectedGender,
                  ),
                );
              }),
            ),
            SizedBox(height: 50),
            Padding(
               padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GestureDetector(
                onTap: _registerUser, // Panggil fungsi registrasi saat tombol ditekan
                child: Container(
                  height: 44,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
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
            )
          ],
        ),
      ),
    );
  }
}
