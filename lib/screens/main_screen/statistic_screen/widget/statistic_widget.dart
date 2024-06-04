import 'package:flutter/material.dart';
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/screens/main_screen/statistic_screen/pages/statistic_detail.dart';


class StatisticWidget extends StatelessWidget {
  final Materi materi;
  final Function(Materi) onSelected;

  const StatisticWidget({
    required this.materi,
    required this.onSelected,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onSelected(materi);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return StatisticDetail(materi: materi);
        }));
      },
      child: Container(
        height: 130,
        width: 130,
        child: Image.network(
          '${materi.imageStatistic}',
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }
}