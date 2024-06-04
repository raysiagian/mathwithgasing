import 'package:flutter/material.dart';
import 'package:mathgasing/core/color/color.dart';
import 'package:mathgasing/models/question_pretest/question_pretest.dart';

class QuestionPretestWidget extends StatefulWidget {
  const QuestionPretestWidget({
    Key? key,
    required this.question,
    required this.indexAction,
    required this.totalQuestion,
    required this.onOptionSelected,
  }) : super(key: key);

  final QuestionPretest question;
  final int indexAction;
  final int totalQuestion;
  final Function(String) onOptionSelected;

  @override
  _QuestionPretestWidgetState createState() => _QuestionPretestWidgetState();
}

class _QuestionPretestWidgetState extends State<QuestionPretestWidget> {
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pertanyaan ${widget.indexAction + 1}/${widget.totalQuestion}:',
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 40),
        Text(
          '${widget.question.question}',
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OptionWidget(
              option: widget.question.pretest_option_1,
              isSelected: selectedOption == widget.question.pretest_option_1,
              onOptionSelected: () => setSelectedOption(widget.question.pretest_option_1),
            ),
            OptionWidget(
              option: widget.question.pretest_option_2,
              isSelected: selectedOption == widget.question.pretest_option_2,
              onOptionSelected: () => setSelectedOption(widget.question.pretest_option_2),
            ),
            OptionWidget(
              option: widget.question.pretest_option_3,
              isSelected: selectedOption == widget.question.pretest_option_3,
              onOptionSelected: () => setSelectedOption(widget.question.pretest_option_3),
            ),
            OptionWidget(
              option: widget.question.pretest_option_4,
              isSelected: selectedOption == widget.question.pretest_option_4,
              onOptionSelected: () => setSelectedOption(widget.question.pretest_option_4),
            ),
          ],
        ),
        // SizedBox(height: 20),
        // if (selectedOption.isNotEmpty)
        //   Text(
        //     'Anda memilih: $selectedOption',
        //     style: TextStyle(
        //       fontSize: 16.0,
        //       color: Colors.black,
        //     ),
        //   ),
      ],
    );
  }

  void setSelectedOption(String option) {
    setState(() {
      selectedOption = option;
    });
    widget.onOptionSelected(option);
  }
}

class OptionWidget extends StatelessWidget {
  final String option;
  final bool isSelected;
  final VoidCallback onOptionSelected;

  const OptionWidget({
    Key? key,
    required this.option,
    required this.isSelected,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOptionSelected,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              option,
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