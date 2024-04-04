import 'package:flutter/material.dart';
import 'package:mathgasing/models/question_pretest/question_pretest.dart';


class QuestionPretestWidget extends StatelessWidget {
  const QuestionPretestWidget({
    Key? key,
    required this.question,
    required this.indexAction,
    required this.totalQuestion,
  }) : super(key: key);

  final QuestionPretest question;
  final int indexAction;
  final int totalQuestion;

  @override
  Widget build(BuildContext context) {
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
          '${question.question}',
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OptionWidget(option: question.option_1),
            OptionWidget(option: question.option_2),
            OptionWidget(option: question.option_3),
            OptionWidget(option: question.option_4),
          ],
        ),
      ],
    );
  }
}

class OptionWidget extends StatefulWidget {
  final String option;

  const OptionWidget({Key? key, required this.option}) : super(key: key);

  @override
  _OptionWidgetState createState() => _OptionWidgetState();
}

class _OptionWidgetState extends State<OptionWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              widget.option,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
