import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mathgasing/models/level/level.dart';
import 'package:mathgasing/models/level_type/pretest.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/question_pretest/question_pretest.dart';
import 'package:mathgasing/models/timer/timer.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/dialog_question_on_close_popup_widget.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/pretest_level_screen/widget/question_pretest_widget.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/selanjutnya_button_widget.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/timer_widget.dart';

class PreTestLevel extends StatefulWidget {
  const PreTestLevel({
    Key? key,
    required this.level,
    required this.materi,
    required this.pretest,
    this.score_pretest,
  }) : super(key: key);

  final Level level;
  final Materi materi;
  final PreTest pretest;
  final int? score_pretest;

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

    @override
  void dispose() {
    timerModel.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        title: Text(
          'Level ${widget.level.level_number}',
          style: TextStyle(
             color: Theme.of(context).primaryColor,
          ),
          ),
      ),
      body: FutureBuilder<List<QuestionPretest>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final questions = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TimerWidget(timerModel: timerModel),
                        SizedBox(height: 20),
                        QuestionPretestWidget(
                          question: questions[index],
                          indexAction: index,
                          totalQuestion: questions.length,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SelanjutnyaButton(
          pertanyaanSelanjutnya: pertanyaanSelanjutnya, onPressed: () {
            
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
