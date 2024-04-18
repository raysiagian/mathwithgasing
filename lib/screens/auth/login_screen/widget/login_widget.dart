import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/screens/auth/registration_screen/pages/registration_page.dart';
import 'package:mathgasing/screens/main_screen/home_wrapper/pages/home_wrapper.dart';

class LoginWidget extends StatefulWidget {
  final ValueChanged<String> onLoginSuccess;

  const LoginWidget({
    Key? key,
    required this.onLoginSuccess,
  }) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final storage = FlutterSecureStorage();

  Future<void> _login(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('https://mathgasing.cloud/api/login'),
        body: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final authToken = responseData['token'];
        final refreshToken = responseData['refresh_token'];
        
        // Simpan token
        await storage.write(key: 'access_token', value: authToken);
        await storage.write(key: 'refresh_token', value: refreshToken);

        widget.onLoginSuccess(authToken); // Notify the parent widget about login success
        // Arahkan pengguna ke halaman HomeWrapper
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeWrapper()),
        );
      } else {
        final responseData = json.decode(response.body);
        final errorMessage = responseData['message'] ?? 'Login gagal';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red, // Changed to a contrasting color
            ),
          );
        }
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan. Silakan coba lagi.'),
            backgroundColor: Colors.red, // Changed to a contrasting color
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 50),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 100),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _login(context);
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Email atau password salah'),
                          backgroundColor: Colors.red, // Changed to a contrasting color
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  height: 44,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Login',
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
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
                      'Daftar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
