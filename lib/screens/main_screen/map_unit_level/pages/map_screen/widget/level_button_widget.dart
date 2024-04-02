import 'package:flutter/material.dart';
import 'package:mathgasing/models/level/level.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/level_type/posttest.dart';
import 'package:mathgasing/models/level_type/pretest.dart';
import 'package:mathgasing/models/question_pretest/question_pretest.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/material_level_page.dart/pages/material_level_page.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/posttest_level_screen/pages/posttest_level_page.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/pretest_level_screen/pages/pretest_level_page.dart';

class LevelButtonWidget extends StatelessWidget {
  LevelButtonWidget({
    Key? key,
    required this.level,
    required this.materi,
  }) : super(key: key);

  final Level level;
  final Materi materi;

  PreTest preTest = PreTest(
    id_pretest: 1,
    questionsPretest: [
      QuestionPretest(
        id_question_pretest: 1,
        question: "1 + 1",
        option_1: "2",
        option_2: "4",
        option_3: "5",
        option_4: "6",
      ),
      QuestionPretest(
        id_question_pretest: 2,
        question: "9 - 3",
        option_1: "6",
        option_2: "3",
        option_3: "2",
        option_4: "0",
      ),
      QuestionPretest(
        id_question_pretest: 3,
        question: "1x1+0",
        option_1: "0",
        option_2: "1",
        option_3: "2",
        option_4: "3",
      ),
    ],
    score: 3,
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (level.level_number == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PreTestLevel(
                level: level,
                materi: materi,
                pretest: preTest,
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              level.level_number.toString(),
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void navigateToScreen(BuildContext context) {
  //   switch (level.level_number) {
  //     case 1:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => PreTestLevel(
  //             level: level,
  //             materi: materi,
  //             pretest: PreTest(
  //               id_pretest: level.id_pretest,
  //               questionsPretest: [], // Provide appropriate list of questions
  //               score: null, // Provide appropriate score value
  //             ),
  //           ),
  //         ),
  //       );
  //       break;
  //     case 2:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => MaterialLevel(
  //             level: level,
  //             materi: materi,
  //           ),
  //         ),
  //       );
  //       break;
  //     case 3:
  //        Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => PostTestLevel(
  //             level: level,
  //             materi: materi,
  //           ),
  //         ),
  //       );
  //       break;
  //     default:
  //       // Handle other cases if needed
  //       break;
  //   }
  // }

//   void navigateToScreen(BuildContext context) {
//   switch (level.level_number) {
//     case 1:
//       if (level.id_pretest != null) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => PreTestLevel(
//               level: level,
//               materi: materi,
//               pretest: PreTest(
//                 id_pretest: level.id_pretest!,
//                 questionsPretest: [], // Provide appropriate list of questions
//                 score: null, // Provide appropriate score value
//               ),
//             ),
//           ),
//         );
//       }
//       break;
//     case 2:
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => MaterialLevel(
//             level: level,
//             materi: materi,
//           ),
//         ),
//       );
//       break;
//     case 3:
//        Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => PostTestLevel(
//             level: level,
//             materi: materi,
//           ),
//         ),
//       );
//       break;
//     default:
//       // Handle other cases if needed
//       break;
//   }
// }

  void navigateToScreen(BuildContext context) {
    switch (level.level_number) {
      case 1:
        if (level.id_pretest != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PreTestLevel(
                level: level,
                materi: materi,
                pretest: PreTest(
                  id_pretest: level.id_pretest!,
                  questionsPretest: [],
                  // Provide appropriate list of questions
                  score: null, // Provide appropriate score value
                ),
              ),
            ),
          );
        }
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MaterialLevel(
              level: level,
              materi: materi,
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostTestLevel(
              level: level,
              materi: materi,
            ),
          ),
        );
        break;
      default:
        // Handle other cases if needed
        print("Unsupported level number: ${level.level_number}");
        break;
    }
  }
}
