import 'package:flutter/material.dart';
import 'package:mathgasing/models/question_posttest/question_posttest.dart';
import 'package:mathgasing/core/color/color.dart';


class QuestionPosttestWidget extends StatefulWidget {
  const QuestionPosttestWidget({
    Key? key,
    required this.question,
    required this.indexAction,
    required this.totalQuestion,
    required this.onOptionSelected,
  }) : super(key: key);

  final QuestionPosttest question;
  final int indexAction;
  final int totalQuestion;
  final Function(String) onOptionSelected;

  @override
  _QuestionPosttestWidgetState createState() => _QuestionPosttestWidgetState();
}

class _QuestionPosttestWidgetState extends State<QuestionPosttestWidget> {
  late String selectedOption; // State untuk menyimpan opsi yang dipilih

  @override
  void initState() {
    super.initState();
    selectedOption = ''; // Set opsi yang dipilih ke string kosong pada awalnya
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
              option: widget.question.option_1,
              isSelected: selectedOption == widget.question.option_1, // Tentukan isSelected berdasarkan opsi yang dipilih
              onOptionSelected: () => setSelectedOption(widget.question.option_1), // Saat opsi dipilih, set opsi yang dipilih
            ),
            OptionWidget(
              option: widget.question.option_2,
              isSelected: selectedOption == widget.question.option_2,
              onOptionSelected: () => setSelectedOption(widget.question.option_2),
            ),
            OptionWidget(
              option: widget.question.option_3,
              isSelected: selectedOption == widget.question.option_3,
              onOptionSelected: () => setSelectedOption(widget.question.option_3),
            ),
            OptionWidget(
              option: widget.question.option_4,
              isSelected: selectedOption == widget.question.option_4,
              onOptionSelected: () => setSelectedOption(widget.question.option_4),
            ),
          ],
        ),
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
  final VoidCallback onOptionSelected; // Callback untuk menangani pemilihan opsi

  const OptionWidget({
    Key? key,
    required this.option,
    required this.isSelected,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOptionSelected, // Panggil callback saat opsi dipilih
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
