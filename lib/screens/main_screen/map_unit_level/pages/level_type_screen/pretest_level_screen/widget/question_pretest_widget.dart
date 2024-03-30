import 'package:flutter/material.dart';

class QuestionPretestWidget extends StatelessWidget {
  const  QuestionPretestWidget({Key? key,
  required this.question,
  required this.indexAction,
  required this.totalQuestion})
      : super(key: key);

  final String question;
  final int indexAction;
  final int totalQuestion;

  @override
  Widget build(BuildContext context){
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pertanyaan ${indexAction + 1}/$totalQuestion:',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 40),
          Text(
            '$question',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.black,
            ),
          ),
        ],
    );
  }

}

