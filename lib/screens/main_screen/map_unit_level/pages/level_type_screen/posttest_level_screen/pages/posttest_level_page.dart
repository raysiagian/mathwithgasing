import 'package:flutter/material.dart' hide Badge;
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/badge/badge.dart';
import 'dart:convert';
import 'package:mathgasing/models/unit/unit.dart';
import 'package:mathgasing/models/level_type/posttest.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/question_posttest/question_posttest.dart';
import 'package:mathgasing/models/timer/timer.dart';
import 'package:mathgasing/models/user/user.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/after_level_screen/pages/after_level_postest.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/after_level_screen/pages/badge_user.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/posttest_level_screen/widget/question_posttest_widget.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/dialog_question_on_close_popup_widget.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/selanjutnya_button_widget.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/timer_widget.dart';
import 'package:mathgasing/core/color/color.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PostTestLevel extends StatefulWidget {
  const PostTestLevel({
    Key? key,
    required this.unit,
    required this.materi,
    required this.posttest,
    this.score_posttest,
  }) : super(key: key);

  final Unit unit;
  final Materi materi;
  final PostTest posttest;
  final int? score_posttest;

  @override
  State<PostTestLevel> createState() => _PostTestLevelState();
}

class _PostTestLevelState extends State<PostTestLevel> {
  int index = 0;
  int totalScore = 0;
  late TimerModel timerModel;
  late List<QuestionPostTest> questions = [];
  String? selectedOption;
  String? lastSelectedOption;
  late String _token;
  late User? _loggedInUser;
  int correctAnswers = 0;
  bool isFirstAttempt = true;
  
  @override
  void initState() {
    super.initState();
     _loadTokenAndFetchUser();
    fetchQuestionPostTest();
    timerModel = TimerModel(
      durationInSeconds: 10,
      onTimerUpdate: updateTimerUI,
      onTimerFinish: timerFinishAction,
    );
    timerModel.startTimer();
  }

  Future<void> _loadTokenAndFetchUser() async {
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

      try {
        bool isFirstAttemptValue = await checkFirstAttempt();
        setState(() {
          isFirstAttempt = isFirstAttemptValue;
        });

        prefs.setBool('isFirstAttempt_${widget.posttest.id_posttest}_${_loggedInUser?.id_user}', isFirstAttemptValue);

        print('isFirstAttempt: $isFirstAttempt');

        fetchQuestionPostTest();
      } catch (e) {
        showErrorDialog('Error loading first attempt: $e');
      }
    } else {
      print('Token not found');
    }
  }

  Future<bool> checkFirstAttempt() async {
    try {
      

      final response = await http.get(
        Uri.parse(baseurl + 'api/checkFirstAttempt?id_posttest=${widget.posttest.id_posttest}'),
        headers: {
          'Authorization' : 'Bearer $_token',
        }
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData['isFirstAttempt'] ?? false; // Jika nilai isFirstAttempt tidak ada, kembalikan false
      } else {
        throw Exception('Failed to check first attempt. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error checking first attempt: $e');
    }
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
  // Check the answer only if an option has been selected
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

  // void checkAnswer(QuestionPostTest currentQuestion, String? selectedOption) {
  //   if (selectedOption != null) {
  //     if (selectedOption == currentQuestion.correct_index) {
  //       increaseScore();
  //       print("Correct answer! Score increased by 10. Total Score: $totalScore");
  //     } else {
  //       print("Wrong answer. Total Score: $totalScore");
  //     }
  //     // Reset selected option after checking the answer
  //     setState(() {
  //       selectedOption = null;
  //     });
  //   } else {
  //     print("No answer given. Total Score: $totalScore");
  //   }
  // }

  void checkAnswer(QuestionPostTest currentQuestion, String? selectedOption) {
  if (lastSelectedOption != null) {
    if (lastSelectedOption == currentQuestion.posttest_correct_index) {
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



  void increaseScore(QuestionPostTest currentQuestion) {
    setState(() {
    if (lastSelectedOption == currentQuestion.posttest_correct_index) {
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
      String? token = _token;
      if (token == null) {
        throw Exception('Token not found');
      }

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      };

      Map<String, dynamic> postData = {
        'id_posttest': widget.posttest.id_posttest,
        'id_unit': widget.unit.id_unit,
        'score': totalScore,
      };

      final response = await http.put(
        Uri.parse(baseurl + 'api/posttest/${widget.posttest.id_posttest}/update-final-score-posttest'),
        body: jsonEncode(postData),
        headers: headers,
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        if (isFirstAttempt && totalScore == 100) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BadgeUserPage(
                id_posttest: widget.posttest.id_posttest,
                materi: widget.materi,
                userId: _loggedInUser!.id_user,
              ),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FinalScorePosttest(score_posttest: totalScore, materi: widget.materi),
            ),
          );
        }

        // Update the first attempt flag
        prefs.setBool('isFirstAttempt_${widget.posttest.id_posttest}_${_loggedInUser!.id_user}', false);
      } else {
        String errorMessage = 'Failed to save score. Status code: ${response.statusCode}';
        if (response.body != null && response.body.isNotEmpty) {
          errorMessage += '\nResponse body: ${response.body}';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      showErrorDialog('Failed to save score. Please try again later.');
    }
  }


  // Future<List<QuestionPostTest>> fetchQuestionPretest() async {
  //   try {
  //     final response = await http
  //         .get(Uri.parse('https://mathgasing.cloud/api/getQuestionPosttest'));

  //     if (response.statusCode == 200) {
  //       final jsonData = jsonDecode(response.body)['data'] as List<dynamic>;
  //       return jsonData.map((e) => QuestionPostTest.fromJson(e)).toList();
  //     } else {
  //       throw Exception('Failed to load questions');
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     return [];
  //   }
  // }

//   Future<List<QuestionPostTest>> fetchQuestionPostTest() async {
//   try {
//     final response = await http
//         .get(Uri.parse('https://mathgasing.cloud/api/getQuestionPosttest'));

//     if (response.statusCode == 200) {
//       final jsonData = jsonDecode(response.body)['data'] as List<dynamic>;
//       final questions = jsonData.map((e) => QuestionPostTest.fromJson(e)).toList();
      
//       // Cetak pertanyaan yang diterima
//       print('Pertanyaan yang diterima:');
//       questions.forEach((question) {
//         print(question); // atau print(question.toJson()) tergantung pada struktur data QuestionPostTest
//       });
      
//       return questions;
//     } else {
//       throw Exception('Failed to load questions');
//     }
//   } catch (e) {
//     print(e.toString());
//     return [];
//   }
// }

 Future<void> fetchQuestionPostTest() async {
    try {
      final response = await http.get(
        Uri.parse(baseurl + 'api/getQuestionByPosttest?id_posttest=${widget.posttest.id_posttest}'),
        // Uri.parse(baseurl + 'api/getQuestionByPretest?id_pretest=${widget.pretest.id_pretest}'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'] as List<dynamic>;
        setState(() {
          questions = jsonData.map((e) => QuestionPostTest.fromJson(e)).toList();
        });
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      print(e.toString());
    }
  }

// Future<void> fetchQuestionPostTest() async {
//   try {
//     // final response = await http.get(Uri.parse(baseurl + 'api/getQuestionByPosttest?id_posttest=${widget.posttest.id_posttest}'));
//     Uri.parse(baseurl + 'api/getQuestionByPosttest?id_posttest=${widget.posttest.id_posttest}');
//     if (response.statusCode == 200) {
//       final jsonData = jsonDecode(response.body)['data'] as List<dynamic>;
//       print('Response Data: $jsonData'); // Menampilkan data yang diterima dari respons API

//       // Debugging: Menampilkan pertanyaan dari respons API
//       for (var i = 0; i < jsonData.length; i++) {
//         final questionData = jsonData[i];
//         final question = QuestionPostTest.fromJson(questionData);
//         print('Question ${i + 1}: ${question.question}');
//       }

//       setState(() {
//         questions = jsonData.map((e) => QuestionPostTest.fromJson(e)).toList();
//       });
//     } else {
//       throw Exception('Failed to load questions');
//     }
//   } catch (e) {
//     print('Error: $e');
//     // Tampilkan pesan kesalahan jika gagal memuat pertanyaan
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: Text('Error'),
//           content: Text('Failed to load questions'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

 void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
          'Level 3',
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
                      QuestionPostTestWidget(
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