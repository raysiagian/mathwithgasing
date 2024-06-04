import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/constants/constants.dart';
import 'dart:convert';
import 'package:mathgasing/models/user/user.dart';
import 'package:mathgasing/models/unit/unit.dart';
import 'package:mathgasing/models/level_type/pretest.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/question_pretest/question_pretest.dart';
import 'package:mathgasing/models/timer/timer.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/after_level_screen/pages/after_level_pretest.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/dialog_question_on_close_popup_widget.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/pretest_level_screen/widget/question_pretest_widget.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/selanjutnya_button_widget.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/timer_widget.dart';
import 'package:mathgasing/core/color/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreTestLevel extends StatefulWidget {
  const PreTestLevel({
    Key? key,
    required this.unit,
    required this.materi,
    required this.pretest,
    this.score_pretest,
  }) : super(key: key);

  final Unit unit;
  final Materi materi;
  final PreTest pretest;
  final int? score_pretest;

  @override
  State<PreTestLevel> createState() => _PreTestLevelState();
}

class _PreTestLevelState extends State<PreTestLevel> {
  int index = 0;
  int totalScore = 0;
  late TimerModel timerModel;
  late List<QuestionPretest> questions = [];
  String? selectedOption;
  String? lastSelectedOption;
  late String _token;
  User? _loggedInUser;
  int correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchUser();
    fetchQuestionPretest();
    timerModel = TimerModel(
      durationInSeconds: 10,
      onTimerUpdate: updateTimerUI,
      onTimerFinish: timerFinishAction,
    );
    timerModel.startTimer();
  }

  Future<String?> _loadTokenAndFetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        _token = token;
      });

      final user = await fetchUser(token);
      setState(() {
        _loggedInUser = user;
      });
    }

    return token;
  }

  Future<User> fetchUser(String token) async {
    try {
      final response = await http.get(
        Uri.parse(baseurl + 'api/user'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return User.fromJson(jsonData);
      } else {
        throw Exception('Failed to load user from API: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
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
    // Check if lastSelectedOption is not null
    if (lastSelectedOption != null) {
      final currentQuestion = questions[index];
      checkAnswer(currentQuestion, lastSelectedOption);
    }
    moveToNextQuestion();
  }

  void setSelectedOption(String option) {
    print("Selected Option: $option");
    if (option != lastSelectedOption) { // Check if the selected option is new
      setState(() {
        lastSelectedOption = option;
      });
    }
  }

  void checkAnswer(QuestionPretest currentQuestion, String? selectedOption) {
    if (lastSelectedOption != null) {
      if (lastSelectedOption == currentQuestion.pretest_correct_index) {
        // Periksa apakah opsi yang dipilih terakhir kali adalah jawaban yang benar
        if (lastSelectedOption == selectedOption) {
          // Jika jawaban terakhir dan jawaban saat ini sama, tambahkan skor
          increaseScore(currentQuestion);
          print("Correct answer! Score increased by 10. Total Score: $totalScore");
        } else {
          print("Wrong answer. Total Score: $totalScore");
        }
      }
      setState(() {
        lastSelectedOption = null; // Reset lastSelectedOption setelah mengecek jawaban
      });
    } else {
      print("No answer given. Total Score: $totalScore");
    }
  }

  void increaseScore(QuestionPretest currentQuestion) {
    setState(() {
      if (lastSelectedOption == currentQuestion.pretest_correct_index) {
        correctAnswers++;
      }
      totalScore = ((correctAnswers / questions.length) * 100).toInt();
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
      try {
        await sendScoreToServer();
      } catch (e) {
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
  }

  Future<void> sendScoreToServer() async {
    try {
      print('Sending score to server...');

      // Retrieve the token asynchronously
      String? token = await _loadTokenAndFetchUser();
      if (token == null) {
        throw Exception('Token not found');
      }

      // Set the request headers
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      };

      Map<String, dynamic> postData = {
        'score': totalScore,
        'id_unit': widget.unit.id_unit,
        'id_pretest': widget.pretest.id_pretest,
      };

      final response = await http.put(
        Uri.parse(baseurl + 'api/pretest/${widget.pretest.id_pretest}/update-final-score-pretest'),
        body: jsonEncode(postData),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print('Score successfully saved.');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FinalScorePretest(score_pretest: totalScore, materi: widget.materi),
          ),
        );
      } else {
        String errorMessage = 'Failed to save score. Status code: ${response.statusCode}';
        if (response.body.isNotEmpty) {
          errorMessage += '\nResponse body: ${response.body}';
        }
        throw Exception(errorMessage);
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack trace: $stackTrace');
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

  Future<void> fetchQuestionPretest() async {
    try {
      final response = await http.get(
        Uri.parse(baseurl + 'api/getQuestionByPretest?id_pretest=${widget.pretest.id_pretest}'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'] as List<dynamic>;
        setState(() {
          questions = jsonData.map((e) => QuestionPretest.fromJson(e)).toList();
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
        centerTitle: true,
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
          'Level 1',
          style: TextStyle(
            color: AppColors.primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TimerWidget(timerModel: timerModel),
                    SizedBox(height: 20),
                    if (questions.isNotEmpty)
                      QuestionPretestWidget(
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
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: questions.isNotEmpty && index < questions.length - 1
            ? SelanjutnyaButton(
                onPressed: pertanyaanSelanjutnya,
              )
            : ElevatedButton(
                onPressed: pertanyaanSelanjutnya,
                child: Container(
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
