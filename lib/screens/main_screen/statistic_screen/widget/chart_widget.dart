import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

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
      body: Column(children: [
         SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(text: 'Half yearly sales analysis'),
              // Enable legend
              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries<_Chart, String>>[
                LineSeries<_Chart, String>(
                    dataSource: data,
                    xValueMapper: (_Chart sales, _) => sales.year,
                    yValueMapper: (_Chart sales, _) => sales.sales,
                    name: 'Sales',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true))
              ]),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              //Initialize the spark charts widget
              child: SfSparkLineChart.custom(
                //Enable the trackball
                trackball: SparkChartTrackball(
                    activationMode: SparkChartActivationMode.tap),
                //Enable marker
                marker: SparkChartMarker(
                    displayMode: SparkChartMarkerDisplayMode.all),
                //Enable data label
                labelDisplayMode: SparkChartLabelDisplayMode.all,
                xValueMapper: (int index) => data[index].year,
                yValueMapper: (int index) => data[index].sales,
                dataCount: 5,
              ),
            ),
          )
      ]),
    );
  }
}

class _Chart {
  _Chart(this.year, this.sales);

  final String year;
  final double sales;
}