import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../database/drift_database.dart';

class LineChartSample2 extends StatefulWidget {
  final String actionName;

  const LineChartSample2({super.key, required this.actionName});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<FlSpot> spotList = [
    FlSpot(0, 0),
    FlSpot(1, 0),
    FlSpot(2, 0),
    FlSpot(3, 0),
    FlSpot(4, 0),
    FlSpot(5, 0),
    FlSpot(6, 0),
  ];
  List<List<int>> spotTemp = [
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0],
  ];

  List<Color> gradientColors = [
    const Color(0xffe1c4f5),
    const Color(0xff7209B7),
  ];

  bool showAvg = false;

  void readDatabase() async {
    final data = await GetIt.I<LocalDatabase>()
        .watchFeedbackScoresAct(widget.actionName);
    print(data);

    DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    for (var element in data) {
      print(element);

      int diff = today.difference(element.createdAt).inDays;
      print("diff : $diff");
      if (diff < 7) {
        spotTemp[diff][1] = (spotTemp[diff][1] + element.score);
        spotTemp[diff][0]++;
      }
    }
    print('${widget.actionName}=============');
    print(spotTemp);
    print('=============');
    setState((){
      spotList = [
        FlSpot(0, spotTemp[6][0] != 0 ? ((spotTemp[6][1]~/spotTemp[6][0])).toDouble() : 0),
        FlSpot(1, spotTemp[5][0] != 0 ? ((spotTemp[5][1]~/spotTemp[5][0])).toDouble(): 0),
        FlSpot(2, spotTemp[4][0] != 0 ? ((spotTemp[4][1]~/spotTemp[4][0])).toDouble(): 0),
        FlSpot(3, spotTemp[3][0] != 0 ? ((spotTemp[3][1]~/spotTemp[3][0])).toDouble(): 0),
        FlSpot(4, spotTemp[2][0] != 0 ? ((spotTemp[2][1]~/spotTemp[2][0])).toDouble(): 0),
        FlSpot(5, spotTemp[1][0] != 0 ? ((spotTemp[1][1]~/spotTemp[1][0])).toDouble(): 0),
        FlSpot(6, spotTemp[0][0] != 0 ? ((spotTemp[0][1]~/spotTemp[0][0])).toDouble(): 0),
      ];
    });

  }

  @override
  void initState() {
    super.initState();
    readDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(18),
              ),
              color: const Color(0xffF8F7FB),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.7),
                  spreadRadius: 0,
                  blurRadius: 2.0,
                  offset: const Offset(5, 5), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                right: 18,
                left: 12,
                top: 24,
                bottom: 12,
              ),
              child: LineChart(
                mainData(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 13,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('6일전', style: style);
        break;
      case 1:
        text = const Text('5일전', style: style);
        break;
      case 2:
        text = const Text('4일전', style: style);
        break;
      case 3:
        text = const Text('3일전', style: style);
        break;
      case 4:
        text = const Text('2일전', style: style);
        break;
      case 5:
        text = const Text('1일전', style: style);
        break;
      case 6:
        text = const Text('today', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 50:
        text = '50';
        break;
      case 100:
        text = '100';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xffe4def5),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xffc1aff5),
            strokeWidth: 5,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xffc1aff5)),
      ),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          preventCurveOverShooting: true,
          spots: spotList,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors:
                  gradientColors.map((color) => color.withOpacity(0)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
