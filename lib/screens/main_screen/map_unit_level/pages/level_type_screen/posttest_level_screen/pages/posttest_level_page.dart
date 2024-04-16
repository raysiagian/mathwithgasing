import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mathgasing/models/level/level.dart';
import 'package:mathgasing/models/level_type/posttest.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/question_posttest/question_posttest.dart';
import 'package:mathgasing/models/timer/timer.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/after_level_screen/pages/after_level_posttest.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/dialog_question_on_close_popup_widget.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/posttest_level_screen/widget/question_posttest_widget.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/selanjutnya_button_widget.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/timer_widget.dart';
import 'package:mathgasing/core/color/color.dart';


class PostTestLevel extends StatefulWidget {
  const PostTestLevel({Key? key,
    required this.level,
    required this.materi,
    required this.posttest,
    this.score_posttest,
  }) : super(key: key);

  final Level level;
  final Materi materi;
  final PostTest posttest;
  final int? score_posttest;

  @override
  State<PostTestLevel> createState() => _PostTestLevelState();
}

class _PostTestLevelState extends State<PostTestLevel> {
  int index = 0;
  late int totalScore = 0;
  late TimerModel timerModel;
  String? selectedOption;
  late List<QuestionPosttest> questions = [];

  @override
  void initState() {
    super.initState();
    fetchQuestionPosttest();
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
    moveToNextQuestion();
  }

  void pertanyaanSelanjutnya() {
    moveToNextQuestion();
  }

  void setSelectedOption(String option) {
    setState(() {
      selectedOption = option;
      final currentQuestion = questions[index];
      checkAnswer(currentQuestion, selectedOption);
    });
  }

  void checkAnswer(QuestionPosttest currentQuestion, String? selectedOption) {
    if (selectedOption != null) {
      if (selectedOption == currentQuestion.correct_index) {
        increaseScore();
        print("Correct answer! Score increased by 10. Total Score: $totalScore");
      } else {
        print("Wrong answer. Total Score: $totalScore");
      }
      // Reset selected option after checking the answer
      setState(() {
        selectedOption = null;
      });
    } else {
      print("No answer given. Total Score: $totalScore");
    }
  }

  void increaseScore() {
    setState(() {
      totalScore += 10;
    });
  }

  void moveToNextQuestion() async {
    if (index < questions.length - 1) {
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
      print("Moving to next question. Index: $index");
    } else {
      // Posttest selesai, kirim skor ke server
      try {
        await sendScoreToServer();
      } catch (e) {
        print('Error: $e');
        // Tampilkan pesan kesalahan jika gagal menyimpan skor
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to save score. Please try again later.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> sendScoreToServer() async {
  try {
    print('Sending score to server...');

    // Create data to be sent in the POST request
    Map<String, dynamic> postData = {
      'id_posttest': widget.posttest.id_posttest,
      'id_level': widget.level.id_level,
      'score_posttest': totalScore,
    };

    // Make the HTTP POST request
    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/api/posttest/${widget.posttest.id_posttest}/update-final-score'),
      body: jsonEncode(postData),
      headers: {'Content-Type': 'application/json'},
    );

    print('Request URL: ${response.request?.url}');
    print('Request Data: ${jsonEncode(postData)}');

    if (response.statusCode == 200) {
      // Handle successful response
      print('Score successfully saved.');
      // Navigate to the final score page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FinalScorePosttest(score_posttest: totalScore, materi: widget.materi),
        ),
      );
    } else {
      // Handle error response
      throw Exception('Failed to save score. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // Handle exceptions
    print('Error: $e');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to save score. Please try again later.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}


  Future<void> fetchQuestionPosttest() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/getQuestionPosttest'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'] as List<dynamic>;
        setState(() {
          questions = jsonData.map((e) => QuestionPosttest.fromJson(e)).toList();
        });
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      print(e.toString());
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
            color: AppColors.primaryColor,
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
             color: AppColors.primaryColor,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TimerWidget(timerModel: timerModel),
                  SizedBox(height: 20),
                  if (questions.isNotEmpty)
                    QuestionPosttestWidget(
                      question: questions[index],
                      indexAction: index,
                      totalQuestion: questions.length,
                      onOptionSelected: setSelectedOption,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: questions.isNotEmpty && index < questions.length - 1
            ? SelanjutnyaButton(
                onPressed: pertanyaanSelanjutnya,
              )
            : ElevatedButton(
                onPressed: pertanyaanSelanjutnya,
                child:Container(
                  height: 44,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Selesai',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
