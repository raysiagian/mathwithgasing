import 'package:flutter/material.dart';

class SelanjutnyaButton extends StatelessWidget {
  const SelanjutnyaButton({Key? key, required this.pertanyaanSelanjutnya}) : super(key: key);
  final VoidCallback pertanyaanSelanjutnya;

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: pertanyaanSelanjutnya,
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
    );
  }
}