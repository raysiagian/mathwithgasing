import 'package:flutter/material.dart';
import 'package:mathgasing/core/color/color.dart';

class QuestionOptionPretestWidget extends StatefulWidget {
  const QuestionOptionPretestWidget({
    Key? key,
    required this.option_1,
    required this.option_2,
    required this.option_3,
    required this.option_4,
    required this.selectedOption,
    required this.onOptionSelected,
  }) : super(key: key);

  final String option_1;
  final String option_2;
  final String option_3;
  final String option_4;
  final String? selectedOption;
  final Function(String) onOptionSelected;

  @override
  _QuestionOptionPretestWidgetState createState() => _QuestionOptionPretestWidgetState();
}

class _QuestionOptionPretestWidgetState extends State<QuestionOptionPretestWidget> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildOption(widget.option_1),
        _buildOption(widget.option_2),
        _buildOption(widget.option_3),
        _buildOption(widget.option_4),
      ],
    );
  }

  Widget _buildOption(String option) {
    final isSelected = widget.selectedOption == option;

    return InkWell(
      onTap: () {
        widget.onOptionSelected(option);
      },
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