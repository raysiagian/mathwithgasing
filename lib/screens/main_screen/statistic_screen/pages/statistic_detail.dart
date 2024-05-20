import 'package:flutter/material.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/screens/main_screen/statistic_screen/widget/chart_widget.dart';
import 'package:mathgasing/screens/main_screen/statistic_screen/widget/table_widget.dart';


class StatisticDetail extends StatefulWidget {
  const StatisticDetail({
    Key? key,
    required this.materi,
  });

  final Materi materi;

  @override
  State<StatisticDetail> createState() => _StatisticDetailState();
}

class _StatisticDetailState extends State<StatisticDetail> {
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
            Navigator.pop(context);
          }
        ),
        title: Text(
          'Statistik ${widget.materi.title}',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
      ),
      body: Stack(children: [
        Column(
          children: [
            ChartWidget(materi: widget.materi),
            SizedBox(height: 10,),
            TableWidget(materi: widget.materi),
          ],),
      ],),
    );
  }
}