import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mathgasing/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:mathgasing/core/color/color.dart';
import 'package:mathgasing/models/level_bonus/level_bonus.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/question_level_bonus/question_level_bonus.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/after_level_screen/pages/after_level_bonus.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/level_bonus_screen/widget/question_level_bonus_widget.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/dialog_lives_reduced.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/dialog_lives_runout.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/dialog_question_on_close_popup_widget.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/selanjutnya_button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LevelBonusPage extends StatefulWidget {
  const LevelBonusPage({
    Key? key,
    required this.levelBonus,
    required this.materi,
    this.score_bonus,
  }) : super(key: key);

  final LevelBonus levelBonus;
  final Materi materi;
  final int? score_bonus;

  @override
  State<LevelBonusPage> createState() => _LevelBonusPageState();
}

class _LevelBonusPageState extends State<LevelBonusPage> {
  int index = 0;
  int totalScore = 0;
  int lives = 3; // Initial number of lives
  late List<QuestionLevelBonus> questions = [];
  String? selectedOption;
  late DateTime lastLeftTime; // Last time leaving the page
  late Timer timer; // Timer to add lives after 5 minutes

  @override
void initState() {
  super.initState();
  getLivesFromSession(); // Get lives from user session when the page is initialized
  fetchQuestionLevelBonus();
  getLastLeftTime(); // Call getLastLeftTime() when the page is initialized
  debugLivesSaved(); // Call the function for debugging
  // If lives are already depleted previously, show the lives run out dialog immediately
  if (lives == 0) {
    _showLivesRunOutDialog(context);
  } else {
    startTimer(); // Start the timer if lives are not depleted yet
  }
}


  @override
  void dispose() {
    saveLastLeftTime(); // Call the method to save the last left time when leaving the page
    timer.cancel(); // Cancel the timer when the page is disposed
    super.dispose();
  }

  void startTimer() {
  const oneSecond = Duration(seconds: 1);
  timer = Timer.periodic(oneSecond, (Timer t) {
    print('Timer started');
    setState(() {
      final currentTime = DateTime.now();
      final difference = currentTime.difference(lastLeftTime);
      final remainingTime = Duration(minutes: 5) - difference;

      if (remainingTime <= Duration.zero) {
        t.cancel(); // Cancel the timer if time is up
        addLife(); // Add life after 5 minutes
        print('Timer stopped');
      } else if (lives < 3) {
        // Calculate additional time based on remaining time from previous life addition
        final additionalTime = Duration(minutes: 5) - difference;
        final remainingWithAdditionalTime = remainingTime + additionalTime;
        if (remainingWithAdditionalTime <= Duration.zero) {
          t.cancel(); // Cancel the timer if time is up after addition
          addLife(); // Add life after 5 minutes
          print('Timer stopped');
        }
      }
    });
  });
}


  void saveLastLeftTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastLeftTime', DateTime.now().toString());
  }

  void getLastLeftTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastLeftTimeString = prefs.getString('lastLeftTime');
    if (lastLeftTimeString != null) {
      lastLeftTime = DateTime.parse(lastLeftTimeString);
      // Check if more than 5 minutes have passed
      if (DateTime.now().difference(lastLeftTime).inMinutes > 5 || lives == 0) {
        // If more than 5 minutes have passed or lives were depleted previously, add one life
        addLife();
      }
    } else {
      lastLeftTime = DateTime.now(); // Set the current time as the last left time
    }
  }

  void addLife() {
    if (lives < 3) {
      // Check if lives are less than 3 before adding
      setState(() {
        lives++;
        saveLives(); // Save the updated lives count
      });
    }
  }

  void saveLives() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userLives', lives); // Save lives to user session
  }

  void getLivesFromSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userLives = prefs.getInt('userLives');
    if (userLives != null) {
      // Use the saved userLives value
      setState(() {
        lives = userLives;
      });
    }
  }

  void debugLivesSaved() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedLives = prefs.getInt('userLives');
    print('Saved Lives: $savedLives');
  }

  Future<void> _showLivesReducedDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogLivesReduced(
          materi: widget.materi,
          lives: lives,
        );
      },
    );
    // Show the dialog for 2 seconds
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pop(); // Close the dialog after 2 seconds
  }

  void _showLivesRunOutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DialogLivesRunOut(
        materi: widget.materi,
      );
    },
  ).then((_) {
    // Start the timer if lives are not depleted
    if (lives > 0) {
      startTimer();
    }
  });
}


  void _showDialogQuestionOnClose(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogQuestionOnClose(
          materi: widget.materi,
        );
      },
    );
  }

  void setSelectedOption(String option) {
    setState(() {
      selectedOption = option;
      final currentQuestion = questions[index];
      checkAnswer(currentQuestion, selectedOption);

      // Update lastLeftTime when user selects an option
      lastLeftTime = DateTime.now();
    });
  }

  bool answerVerified = false; // Add a flag to mark that the answer has been verified and is wrong

  void checkAnswer(QuestionLevelBonus currentQuestion, String? selectedOption) {
    if (selectedOption != null) {
      if (selectedOption == currentQuestion.correct_index) {
        increaseScore();
        print("Correct answer! Score increased by 10. Total Score: $totalScore");
      } else {
        print("Wrong answer. Total Score: $totalScore");
        // Set flag that answer has been verified and is wrong
        answerVerified = true;
      }
    } else {
      print("No answer given. Total Score: $totalScore");
    }
  }

  void increaseScore() {
    setState(() {
      totalScore += 10;
    });
  }

  void moveToNextQuestion() {
    if (index < questions.length - 1) {
      setState(() {
        index++; // Increment the index
        selectedOption = null; // Reset selected option
      });
    }
  }

  void pertanyaanSelanjutnya() {
  // Check if the user has previously given a wrong answer and verify it
  if (answerVerified) {
    // Lose a life because the answer was wrong
    loseLife();
    // Reset the flag for next usage
    answerVerified = false;
  }
  
  // Print debug info
  print('Timer updated before moving to the next question: $lastLeftTime');
  moveToNextQuestion(); // Move to the next question
  
  // Start the timer after moving to the next question
  startTimer();
}



  void loseLife() {
  setState(() {
    lives--; // Decrease the number of lives
    // Reset lastLeftTime to current time plus remaining time from the previous timer value
    lastLeftTime = DateTime.now().add(lastLeftTime.difference(DateTime.now()));
    saveLives(); // Save the updated lives count
    // Store the remaining time before losing a life
    SharedPreferences.getInstance().then((prefs) {
      final currentTime = DateTime.now();
      final difference = currentTime.difference(lastLeftTime);
      final remainingTime = Duration(minutes: 5) - difference;
      prefs.setInt('remainingTime', remainingTime.inSeconds);
    });
  });
}


  String formatDuration(Duration duration) {
    return '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  Future<void> sendScoreToServer() async {
    try {
      print('Sending score to server...');

      // Create data to be sent in the POST request
      Map<String, dynamic> postData = {
        'id_level_bonus': widget.levelBonus.id_level_bonus,
        'score_bonus': totalScore,
      };

      // Make the HTTP POST request
      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/api/levelbonus/${widget.levelBonus.id_level_bonus}/update-final-score'),
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
            builder: (context) => FinalScoreBonus(score_bonus: totalScore, materi: widget.materi),
          ),
        );
      } else {
        // Handle error response
        throw Exception('Failed to save score. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
      showErrorDialog('Failed to save score. Please try again later.');
    }
  }

  Future<void> fetchQuestionLevelBonus() async {
    try {
      final response = await http.get(Uri.parse(baseurl + 'api/getQuestionLevelBonus'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'] as List<dynamic>;
        setState(() {
          questions = jsonData.map((e) => QuestionLevelBonus.fromJson(e)).toList();
        });
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      print(e.toString());
      showErrorDialog('Failed to load questions. Please try again later.');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
              onPressed: () {
                _showDialogQuestionOnClose(context);
              },
            ),
            Text(
              'Level Akhir ${widget.levelBonus.level_number}',
              style: TextStyle(
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(width: 10),
            if (lives > 0)
              Row(
                children: List.generate(
                  lives,
                      (index) => Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Image.asset(
                      'assets/images/love_icon.png',
                      color: AppColors.primaryColor,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
            SizedBox(width: 10),
            if (lives < 3)
              TimerWidget(lastLeftTime: lastLeftTime), // Add TimerWidget here
          ],
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  if (questions.isEmpty)
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  else
                    QuestionLevelBonusWidget(
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
          onPressed: () {
            // Call the method to send the score to the server
            sendScoreToServer();
          },
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


class TimerWidget extends StatelessWidget {
  final DateTime lastLeftTime;

  const TimerWidget({
    Key? key,
    required this.lastLeftTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now();
    final difference = lastLeftTime.difference(currentTime); // Calculate difference in time
    final remainingTime = Duration(minutes: 5) + difference; // Add the difference to the initial 5 minutes
    final formattedMinutes = remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0');
    final formattedSeconds = remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0');
    final formattedTime = '$formattedMinutes:$formattedSeconds';
    return Row(
      children: [
        SizedBox(width: 5), // Space between love icon and timer
        Text(
          'Timer: $formattedTime',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}