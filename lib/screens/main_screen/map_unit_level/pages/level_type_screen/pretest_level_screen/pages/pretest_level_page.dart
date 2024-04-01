import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mathgasing/models/level/level.dart';
import 'package:mathgasing/models/level_type/pretest.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/question_pretest/question_pretest.dart';
import 'package:mathgasing/models/timer/timer.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/dialog_question_on_close_popup_widget.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/selanjutnya_button_widget.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/pretest_level_screen/widget/question_option_pretest_widget.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/pretest_level_screen/widget/question_pretest_widget.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/timer_widget.dart';

class PreTestLevel extends StatefulWidget {
  const PreTestLevel({
    Key? key,
    required this.level,
    required this.materi, 
    required this.pretest, 
    this.score,
  }) : super(key: key);

  final Level level;
  final Materi materi;
  final PreTest pretest;
  final int? score;

  @override
  State<PreTestLevel> createState() => _PreTestLevelState();
}

class _PreTestLevelState extends State<PreTestLevel> {
  int index = 0;
  late int totalScore = 0;
  late TimerModel timerModel;
  String? selectedOption;
  late Future<List<QuestionPretest>> _questionsFuture;

  @override
  void initState() {
    super.initState();
    _questionsFuture = fetchQuestionPretest();
    timerModel = TimerModel(
      durationInSeconds: 10,
      onTimerUpdate: updateTimerUI,
      onTimerFinish: timerFinishAction,
    );
    timerModel.startTimer();
  }

  Future<List<QuestionPretest>> fetchQuestionPretest() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/getQuestionPretest'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'] as List<dynamic>;
        return jsonData.map((e) => QuestionPretest.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  void updateTimerUI(int remainingTime) {
    setState(() {});
  }

  void timerFinishAction() async {
    timerModel.dispose();

    await Future.delayed(Duration(seconds: 1));

    int currentScore = calculateScore();

    if (index < widget.level.questionsPretest.length - 1) {
      setState(() {
        index++;
        totalScore += currentScore;
        selectedOption = null;

        timerModel = TimerModel(
          durationInSeconds: 10,
          onTimerUpdate: updateTimerUI,
          onTimerFinish: timerFinishAction,
        );
        timerModel.startTimer();
      });
    } else {
      print("All questions answered");
      print("Total Score: $totalScore");
    }
  }

  int calculateScore() {
    int currentScore = 0;
    final currentQuestion = widget.level.questionsPretest[index];

    currentQuestion.options.forEach((key, value) {
      if (value && selectedOption == key) {
        currentScore += 10;
      }
    });
    return currentScore;
  }

  void pertanyaanSelanjutnya() {
    if (index < widget.level.questionsPretest.length - 1) {
      setState(() {
        index++;
        selectedOption = null;

        timerModel.dispose();
        timerModel = TimerModel(
          durationInSeconds: 10,
          onTimerUpdate: updateTimerUI,
          onTimerFinish: timerFinishAction,
        );
        timerModel.startTimer();
      });
    }
  }

  @override
  void dispose() {
    timerModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return DialogQuestionOnClose(materi: widget.materi);
              },
            );
          },
        ),
        title: Text('Level ${widget.level.number}'),
      ),
      body: FutureBuilder<List<QuestionPretest>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final questions = snapshot.data ?? [];
            if (questions.isEmpty) {
              return Center(child: Text('No questions available'));
            }
            final question = questions[index];
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TimerWidget(timerModel: timerModel),
                        QuestionPretestWidget(
                          question: question.question,
                          indexAction: index,
                          totalQuestion: questions.length,
                      //  option_1: question.option_1,
                      //  option_2: question.option_2,
                      //  option_3: question.option_3,
                      //  option_4: question.option_4,
                      //  selectedOption: selectedOption,
                      //  onOptionSelected: (option) {
                      //   setState(() {
                      //     selectedOption = option;
                      //   });
                      // },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 100),
                  Container(
                    child: QuestionOptionPretestWidget(
                      option_1: question.option_1,
                      option_2: question.option_2,
                      option_3: question.option_3,
                      option_4: question.option_4,
                      selectedOption: selectedOption,
                      onOptionSelected: (option) {
                        setState(() {
                          selectedOption = option;
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SelanjutnyaButton(
          pertanyaanSelanjutnya: pertanyaanSelanjutnya,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
