import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class _Chart {
  _Chart(this.year, this.sales);

  final String year;
  final double sales;
}

class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  List<_Chart> data = [
    _Chart('Unit 1', 35),
    _Chart('Unit 2', 28),
    _Chart('Unit 3', 34),
    _Chart('Unit 4', 32),
    _Chart('Unit 5', 40)
  ];
  @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Center(
                child: Container(
                    child: SfCartesianChart(
                        title: ChartTitle(text: 'Half yearly sales analysis'),
                        // Initialize category axis
                        primaryXAxis: CategoryAxis(),
                        series: <CartesianSeries>[
                            // Initialize line series
                            LineSeries<ChartData, String>(
                                dataSource: [
                                    // Bind data source
                                    ChartData('Jan', 35),
                                    ChartData('Feb', 28),
                                    ChartData('Mar', 34),
                                    ChartData('Apr', 32),
                                    ChartData('May', 40)
                                ],
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                // Render the data label
                                dataLabelSettings:DataLabelSettings(isVisible : true)
                            )
                        ]
                    )
                )
            )
        );
    }
}
  class ChartData {
      ChartData(this.x, this.y);
      final String x;
      final double? y;
  }
