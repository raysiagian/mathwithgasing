import 'package:flutter/material.dart';
import 'package:mathgasing/models/level/level.dart';
import 'package:mathgasing/models/materi/materi.dart';

class LevelButtonWidget extends StatelessWidget {
  const LevelButtonWidget({
    Key? key,
    required this.level,
    required this.materi,
  }) : super(key: key);

  final Level level;
  final Materi materi;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LevelPageRoute(level: level, materi: materi),
          ),
        );
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
}

class LevelPageRoute extends StatelessWidget {
  const LevelPageRoute({
    Key? key,
    required this.level,
    required this.materi,
  }) : super(key: key);

  final Level level;
  final Materi materi;

  @override
  Widget build(BuildContext context) {
    // Tentukan rute berdasarkan nomor level
    switch (level.level_number) {
      case 1:
        Navigator.pushNamed(context, '/pretestScreen');
        break;
      case 2:
        Navigator.pushNamed(context, '/materialScreen');
        break;
      case 3:
        Navigator.pushNamed(context, '/posttestScreen');
        break;
      default:
        // Do something if level_number is not 1, 2, or 3
        break;
    }
    return Container(); // Return widget sesuai kebutuhan
  }
}
