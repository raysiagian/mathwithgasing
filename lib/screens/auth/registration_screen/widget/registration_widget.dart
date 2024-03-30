import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mathgasing/screens/auth/login_screen/pages/login_page.dart';
import 'package:mathgasing/screens/auth/registration_screen/pages/genderchoose_page.dart';
import 'package:mathgasing/screens/auth/registration_screen/widget/textfield_registration_widget.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({
    Key? key,
    required this.name,
    required this.email,
    required this.password,
  }) : super(key: key);

  final String name;
  final String email;
  final String password;

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isEmailValid(String email) {
    // Regular expression for email validation
    String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(emailRegex);
    return regExp.hasMatch(email);
  }

  Future<bool> _isEmailAvailable(String email) async {
    try {
      final response = await http.get('http://10.0.2.2:8000/api/checkemail' as Uri);
      if (response.statusCode == 200) {
        // Email available
        return true;
      } else {
        // Email not available
        return false;
      }
    } catch (e) {
      // Error occurred, handle accordingly
      return false;
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
              TextFieldRegisterWidget(
                controller: _nameController,
                label: 'Nama',
                validator: (value) {
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFieldRegisterWidget(
                controller: _emailController,
                label: 'Email',
                validator: (value) {
                  if (!_isEmailValid(value!)) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFieldRegisterWidget(
                controller: _passwordController,
                label: 'Password',
                isPassword: true,
              ),
              SizedBox(height: 100),
              GestureDetector(
                onTap: () async {
                  if (!_formKey.currentState!.validate()) return;

                  bool isEmailValid = _isEmailValid(widget.email);
                  if (!isEmailValid) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Email tidak valid'),
                      ),
                    );
                    return;
                  }

                  bool isEmailAvailable = await _isEmailAvailable(widget.email);
                  if (!isEmailAvailable) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Email sudah terdaftar'),
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenderChoose(
                        name: _nameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                      ),
                    ),
                  );
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
                    'Selanjutnya',
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
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
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
                      'Login',
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
