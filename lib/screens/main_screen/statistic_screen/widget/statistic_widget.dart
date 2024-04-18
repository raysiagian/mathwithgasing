import 'package:flutter/material.dart';
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/screens/main_screen/statistic_screen/pages/statistic_detail.dart';

class StatisticWidget extends StatelessWidget {
  const StatisticWidget({
    required this.materi,
    super.key
    });

    final Materi materi;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return StatisticDetail(materi: materi,);
        }));
      },
      child: Container(
        height: 160,
        width: 160,
        child: Image.network(
         baseurl +'storage/${materi.imageStatistic.replaceFirst('public/', '')}',
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }
}