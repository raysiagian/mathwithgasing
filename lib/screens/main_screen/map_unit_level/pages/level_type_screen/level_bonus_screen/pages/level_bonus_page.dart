import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mathgasing/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:mathgasing/core/color/color.dart';
import 'package:mathgasing/models/level_bonus/level_bonus.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/question_level_bonus/question_level_bonus.dart';
import 'package:mathgasing/models/unit_bonus/unit_bonus.dart';
import 'package:mathgasing/models/user/user.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/after_level_screen/pages/after_level_bonus.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/level_bonus_screen/widget/question_level_bonus_widget.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/level_bonus_screen/widget/timer_widget_bonus.dart';
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
    required this.unit_bonus,
    this.score,
  }) : super(key: key);

  final LevelBonus levelBonus;
  final Materi materi;
  final UnitBonus unit_bonus;
  final int? score;

  @override
  State<LevelBonusPage> createState() => _LevelBonusPageState();
}

class _LevelBonusPageState extends State<LevelBonusPage> {
  int index = 0;
  int totalScore = 0;
  int lives = 3; // Initial number of lives
  List<QuestionLevelBonus> questions = [];
  String? selectedOption;
  late DateTime lastLeftTime; // Last time leaving the page
  late Timer timer; // Timer to add lives after 5 minutes
  late String _token;
  late User? _loggedInUser;

  @override
void initState() {
  super.initState();
  _loadTokenAndFetchUser().then((token) {
    if (token != null) {
      fetchLivesFromServer(); // Get lives from backend when the page is initialized
      fetchQuestionLevelBonus();
      getLastLeftTime(); // Call getLastLeftTime() when the page is initialized
      debugLivesSaved(); // Call the function for debugging
      // If lives are already depleted previously, show the lives run out dialog immediately
      if (lives == 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showLivesRunOutDialog(context);
        });
      } else {
        startTimer(); // Start the timer if lives are not depleted yet
      }
    }
  });
}

  Future<String?> _loadTokenAndFetchUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token != null) {
    setState(() {
      _token = token;
    });

    try {
      // Load user using token
      final user = await fetchUser(token);
      setState(() {
        _loggedInUser = user;
      });
      return token; // Return the token value
    } catch (e) {
      print('Error fetching user: $e');
      // Handle error fetching user
      return null;
    }
  } else {
    // Handle case where token is null
    return null;
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

  @override
  void dispose() {
    saveLastLeftTime(); // Call the method to save the last left time when leaving the page
    if (timer.isActive) {
      timer.cancel(); // Cancel the timer when the page is disposed
    }
    super.dispose();
  }

  Future<void> fetchLivesFromServer() async {
    try {
      final userId = _loggedInUser?.id_user ?? '';
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/user/$userId/lives'));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          lives = jsonResponse['lives'];
        });
        saveLives(lives); // Save lives to local storage
        print('Lives retrieved from server: $lives');
      } else {
        throw Exception('Failed to load lives from server');
      }
    } catch (e) {
      print('Error fetching lives: $e');
      showErrorDialog('Failed to load lives. Please try again later.');
    }
  }

  Future<void> updateLivesOnServer(int updatedLives) async {
  try {
    String? token = await _loadTokenAndFetchUser();
    if (token == null) {
      throw Exception('Token not found');
    }

    final userId = _loggedInUser?.id_user ?? '';

    // Buat data untuk dikirim dalam permintaan PUT
    Map<String, dynamic> postData = {
      'lives': updatedLives,
    };

    // Kirim permintaan HTTP PUT ke server
    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/api/users/$userId/update-lives'),
      body: jsonEncode(postData),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Request URL: ${response.request?.url}');
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('User lives updated successfully.');
    } else {
      String errorMessage = 'Failed to update user lives. Status code: ${response.statusCode}';
      if (response.body != null && response.body.isNotEmpty) {
        errorMessage += '\nResponse body: ${response.body}';
      }
      throw Exception(errorMessage);
    }
  } catch (e) {
    print('Error updating user lives: $e');
    showErrorDialog('Failed to update user lives. Please try again later.');
  }
}

  Future<String> getUserIdFromSession() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');
  if (userId != null) {
    return userId;
  } else {
    throw Exception('User ID not found in session');
  }
}


  void startTimer() {
  const oneSecond = Duration(seconds: 1);
  timer = Timer.periodic(oneSecond, (Timer t) {
    setState(() {
      final currentTime = DateTime.now();
      final difference = currentTime.difference(lastLeftTime);
      final remainingTime = Duration(minutes: 5) - difference;

      if (remainingTime <= Duration.zero) {
        if (lives < 3 && lives == 1) {
          addLife(); // Add life after 5 minutes
        }
        // Reset the last left time regardless of lives
        lastLeftTime = DateTime.now();
      }
    });
  });
}


  void saveLastLeftTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime currentTime = DateTime.now();
    await prefs.setString('lastLeftTime', currentTime.toIso8601String());
  }

  void getLastLeftTime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? lastLeftTimeString = prefs.getString('lastLeftTime');
  if (lastLeftTimeString != null) {
    lastLeftTime = DateTime.parse(lastLeftTimeString);
    int remainingTime = Duration(minutes: 5).inSeconds - DateTime.now().difference(lastLeftTime).inSeconds;
    if (remainingTime > 0) {
      lives += remainingTime ~/ Duration(minutes: 5).inSeconds;
      lives = lives.clamp(0, 3); // Ensure lives don't exceed 3
    }
  } else {
    lastLeftTime = DateTime.now();
  }
}

  void addLife() {
  setState(() {
    if (lives < 3 && lives == 1) {
      lives++;
      saveLives(lives); // Simpan jumlah nyawa yang diperbarui
      lastLeftTime = DateTime.now(); // Reset waktu terakhir meninggalkan halaman
      updateLivesOnServer(lives); // Perbarui nyawa di server
      startTimer(); // Mulai ulang timer untuk nyawa berikutnya
    }
  });
}



  void saveLives(int lives) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userLives', lives); // Save lives to user session
    print('Lives saved: $lives');
  }

  void getLivesFromSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userLives = prefs.getInt('userLives');
    if (userLives != null) {
      setState(() {
        lives = userLives;
      });
      print('Lives retrieved: $userLives');
    }
  }

  void debugLivesSaved() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedLives = prefs.getInt('userLives');
    print('Debug: Lives saved in session: $savedLives');
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
  await Future.delayed(Duration(seconds: 2));

  // Setelah dialog ditutup, perbarui jumlah nyawa pengguna di backend
  await updateLivesOnServer(lives);
  Navigator.of(context).pop();
}

  void _showLivesRunOutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DialogLivesRunOut(
        materi: widget.materi,
      );
    },
  );

  // Setelah dialog ditutup, perbarui jumlah nyawa pengguna di backend
  updateLivesOnServer(lives);
}

  void _showDialogQuestionOnClose(BuildContext context) {
    if (lives > 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogQuestionOnClose(
            materi: widget.materi,
          );
        },
      );
    } else {
      _showLivesRunOutDialog(context);
    }
  }

  void setSelectedOption(String option) {
  setState(() {
    selectedOption = option;
  });
}

void checkAndProceed() {
  final currentQuestion = questions[index];
  if (selectedOption == currentQuestion.correct_index) {
    setState(() {
      totalScore++;
    });
  } else {
    setState(() {
      lives--;
      saveLives(lives); // Save the updated lives count
    });
    if (lives == 0) {
      _showLivesRunOutDialog(context);
      return; // Stop further execution if lives are 0
    } else {
      _showLivesReducedDialog(context);
    }
  }

  if (index < questions.length - 1) {
    setState(() {
      index++;
      selectedOption = null; // Reset selected option for the next question
    });
  } else {
    _navigateToAfterLevelBonus();
  }
}




  void checkAnswer(QuestionLevelBonus question, String? selectedOption) {
    if (selectedOption == question.correct_index) {
      setState(() {
        totalScore++;
      });
    } else {
      setState(() {
        lives--;
        saveLives(lives); // Save the updated lives count
        updateLivesOnServer(lives); 
      });
      if (lives == 0) {
        _showLivesRunOutDialog(context);
      } else {
        _showLivesReducedDialog(context);
      }
    }

    if (index < questions.length - 1) {
      setState(() {
        index++;
      });
    } else {
      _navigateToAfterLevelBonus();
    }
  }

  void _navigateToAfterLevelBonus() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FinalScoreBonus(
          materi: widget.materi,
          score: totalScore,
        ),
      ),
    );
  }

  Future<void> sendScoreToServer() async {
  try {
    print('Sending score to server...');

    String? token = await _loadTokenAndFetchUser();
    if (token == null) {
      throw Exception('Token not found');
    }

    // Create data to be sent in the POST request
    Map<String, dynamic> postData = {
      'id_level_bonus': widget.levelBonus.id_level_bonus,
      'score': totalScore,
      'id_unit_Bonus': widget.unit_bonus.id_unit_Bonus,

    };

    // Make the HTTP POST request
    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/api/levelbonus/${widget.levelBonus.id_level_bonus}/update-final-score-level-bonus'),
      body: jsonEncode(postData),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Request URL: ${response.request?.url}');
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      // Handle successful response
      print('Score successfully saved.');
      // Navigate to the final score page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FinalScoreBonus(score: totalScore, materi: widget.materi),
        ),
      );
    } else {
      String errorMessage = 'Failed to save score. Status code: ${response.statusCode}';
      if (response.body != null && response.body.isNotEmpty) {
        errorMessage += '\nResponse body: ${response.body}';
      }
      throw Exception(errorMessage);
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


  Future<void> fetchQuestionLevelBonus() async {
  try {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/getQuestionLevelBonus'));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> questionsData = jsonResponse['data'];
      setState(() {
        questions = questionsData.map((data) => QuestionLevelBonus.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load questions from server');
    }
  } catch (e) {
    print('Error fetching questions: $e');
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
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
              TimerWidgetBonus(lastLeftTime: lastLeftTime),
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
          onPressed: () {
            if (selectedOption != null) {
              checkAndProceed();
            } else {
              showErrorDialog('Pilih salah satu jawaban sebelum melanjutkan.');
            }
          },
        )
      : ElevatedButton(
          onPressed: sendScoreToServer,
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

class SelanjutnyaButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SelanjutnyaButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Container(
        height: 44,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Selanjutnya',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

