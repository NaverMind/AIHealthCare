import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:senior_fit_1/screens/for_chart.dart';
import 'package:senior_fit_1/screens/for_pichart.dart';

import '../database/drift_database.dart';

class NoteDetail extends StatefulWidget {
  final String actionName;

  const NoteDetail({Key? key, required this.actionName}) : super(key: key);

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  int bestSeScore = 0;
  int worstSeScore = 101;
  String bestSeDate = '0000.00.00';
  String worstSeDate = '0000.00.00';
  int partCounter = 0;
  List<MapEntry<String, int>> sortedNotePartCounter = [];

  @override
  void initState() {
    super.initState();
    readDatabase();
  }

  void readDatabase() async {
    final data = await GetIt.I<LocalDatabase>()
        .watchFeedbackScoresAct(widget.actionName);
    print(data);

    DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    List<List<int>> spotTemp = [
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
    ];

    Map<String, int> notePartCounter = {};

    for (var element in data) {
      print(element);

      int diff = today.difference(element.createdAt).inDays;
      print("diff : $diff");
      if (diff < 7) {
        spotTemp[diff][1] = (spotTemp[diff][1] + element.score);
        spotTemp[diff][0]++;
      }
      if (diff < 31) {
        partCounter++;
        if (notePartCounter.containsKey(element.part)) {
          notePartCounter[element.part] = notePartCounter[element.part]! + 1;
        } else {
          notePartCounter[element.part] = 1;
        }
      }
    }
    sortedNotePartCounter = notePartCounter.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // TODO: 파이차트 max 몇개인지 정해야함 나머지는 기타로 취급
    int maxLength = 3;
    if (sortedNotePartCounter.length > maxLength) {
      sortedNotePartCounter[maxLength] =
          MapEntry('etc', sortedNotePartCounter[maxLength].value);
      for (int i = maxLength + 1; i < sortedNotePartCounter.length; i++) {
        sortedNotePartCounter[maxLength] = MapEntry(
            'etc',
            sortedNotePartCounter[maxLength].value +
                sortedNotePartCounter[i].value);
      }
      while (sortedNotePartCounter.length > maxLength + 1) {
        sortedNotePartCounter.removeLast();
      }
    }
    print('👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋');
    print(sortedNotePartCounter);
    print('횟수 $partCounter');
    print('=============');
    setState(() {
      for (int i = 0; i < spotTemp.length; i++) {
        if (spotTemp[i][0] != 0) {
          if (spotTemp[i][1] > bestSeScore) {
            DateTime day = DateTime.now().add(Duration(days: -i));
            bestSeDate = '${day.year}.${day.month}.${day.day}';
            bestSeScore = spotTemp[i][1] ~/ spotTemp[i][0];
          }
          if (spotTemp[i][1] < worstSeScore) {
            DateTime day = DateTime.now().add(Duration(days: -i));
            worstSeDate = '${day.year}.${day.month}.${day.day}';
            worstSeScore = spotTemp[i][1] ~/ spotTemp[i][0];
          }
        }
      }
      if (worstSeScore == 101) {
        worstSeScore = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(widget.actionName),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 23),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                LineChartSample2(
                  actionName: widget.actionName,
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 10,
                  ),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Weekly',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 21),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          '최고의 세션',
                          style: TextStyle(
                              color: Color(0xff868686),
                              fontWeight: FontWeight.w600,
                              fontSize: 21),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset('images/free-icon-trophy-5903915 1.png'),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              children: [
                                Text(
                                  bestSeScore.toString(),
                                  style: TextStyle(
                                    color: Color(0xff169901),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  bestSeDate,
                                  style: TextStyle(
                                    color: Color(0xff868686),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '최악의 세션',
                          style: TextStyle(
                              color: Color(0xff868686),
                              fontWeight: FontWeight.w600,
                              fontSize: 21),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset('images/plaster1.png'),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              children: [
                                Text(
                                  worstSeScore.toString(),
                                  style: TextStyle(
                                    color: Color(0xffFF0000),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  worstSeDate,
                                  style: TextStyle(
                                    color: Color(0xff868686),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 10,
                  ),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Monthly   ',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 21),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    children: [
                      Text(
                        '최근 한달간 교정 필요 부위',
                        style: TextStyle(
                            color: Color(0xff868686),
                            fontWeight: FontWeight.w600,
                            fontSize: 21),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: NotePieChart(
                    actionName: widget.actionName,
                    totalCount: partCounter,
                    notePart: sortedNotePartCounter,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
