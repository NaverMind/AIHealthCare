import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import '../database/drift_database.dart';

/// Icons by svgrepo.com (https://www.svgrepo.com/collection/job-and-professions-3/)
class NotePieChart extends StatefulWidget {
  final String actionName;
  final int totalCount;
  final List<MapEntry<String, int>> notePart;

  const NotePieChart({super.key, required this.actionName, required this.totalCount, required this.notePart});

  @override
  State<StatefulWidget> createState() => _NotePieChart();
}

class _NotePieChart extends State<NotePieChart> {
  int touchedIndex = 10;


  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 0,
              sections: showingSections(),
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(widget.notePart.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 19.0 : 14.0;
      final radius = isTouched ? 160.0 : 150.0;
      final widgetSize = isTouched ? 55.0 : 40.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff4B12BC),
            value: (widget.notePart[i].value/widget.totalCount)*100,
            title: '${((widget.notePart[i].value/widget.totalCount)*100).toInt()}%\n${widget.notePart[i].key}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xff0059FF),
            value: (widget.notePart[i].value/widget.totalCount)*100,
            title: '${((widget.notePart[i].value/widget.totalCount)*100).toInt()}%\n${widget.notePart[i].key}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),

          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff007EFF),
            value: (widget.notePart[i].value/widget.totalCount)*100,
            title: '${((widget.notePart[i].value/widget.totalCount)*100).toInt()}%\n${widget.notePart[i].key}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),

            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff009EFF),
            value: (widget.notePart[i].value/widget.totalCount)*100,
            title: '${((widget.notePart[i].value/widget.totalCount)*100).toInt()}%\n${widget.notePart[i].key}',

            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),

            badgePositionPercentageOffset: .98,
          );
        default:
          return PieChartSectionData(
            color: const Color(0xff00B9FF),
            value: (widget.notePart[i].value/widget.totalCount)*100,
            title: '${((widget.notePart[i].value/widget.totalCount)*100).toInt()}%\n${widget.notePart[i].key}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),

            badgePositionPercentageOffset: .98,
          );
      }
    });
  }
}
