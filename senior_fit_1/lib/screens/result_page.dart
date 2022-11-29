import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:senior_fit_1/database/drift_database.dart';

class ResultPage extends StatefulWidget {
  final DateTime startTime;
  final actionname;

  const ResultPage(
      {Key? key, required this.actionname, required this.startTime})
      : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  int activeScore = 0;
  bool dbIsEmpty = false;
  List<Feed> feedList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readDatabase();
  }

  void readDatabase() async {
    final data =
        await GetIt.I<LocalDatabase>().watchFeedbackScores(widget.startTime);
    print(data);
    if (data.isEmpty) {
      dbIsEmpty = true;
      return;
    }
    for (var element in data) {
      print(element);
      activeScore += element.score;
      bool isMatch = false;
      if (element.feedback == '훌륭한 자세입니다!') {
        continue;
      }
      for (int i = 0; i < feedList.length; i++) {
        if (feedList[i].feedback == element.feedback) {
          feedList[i].cnt++;
          isMatch = true;
          break;
        }
      }
      if (!isMatch) {
        feedList.add(Feed(element.feedback, 1));
      }
    }

    setState(() {
      feedList.sort((a, b) => a.cnt.compareTo(b.cnt));
      activeScore ~/= data.length;
      print(activeScore);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(height: 60,),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Text(
                      widget.actionname,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color(0xffE1D9FC),
                    ),
                  ),
                  SizedBox(height: 25,),
                  Image.asset('images/free-icon-score-7858570 1.png'),
                  SizedBox(height: 25,),
                  Text(
                    '운동 점수는',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 25),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    '${activeScore.toString()}점',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff560BAD),
                        fontSize: 50),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    '입니다',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 25),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              color: Color(0xffF8F7FB),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Image.asset('images/free-icon-exercise-168315.png'),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '이런 부분이 아쉬워요!',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20),
                    ),
                    Expanded(
                      child: feedList.isNotEmpty
                          ? ListView.builder(
                              itemCount: feedList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  leading: Container(
                                      width: 30.0,
                                      height: 30.0,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 3.0,
                                          color: Colors.purple,
                                        ),
                                        color: (index != 0)
                                            ? Colors.white
                                            : Color(0xff8B2CF5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                          child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: (index == 0)
                                              ? Colors.white
                                              : Color(0xff8B2CF5),
                                        ),
                                      ))),
                                  title: Text(
                                    feedList[index].feedback,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: (index != 0)
                                            ? Colors.black
                                            : Color(0xff8B2CF5),
                                        fontSize: 20),
                                  ),
                                  subtitle: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: Row(
                                      children: [
                                        Text(
                                          '${feedList[index].cnt}회 ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: (index != 0)
                                                  ? Colors.black
                                                  : Colors.red,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          '실수',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : Text('empty'),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                        child: Text(
                          '처음으로',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Color(0xff560BAD),
                        ),
                      ),
                    ),
                    SizedBox(height: 30,)
                  ],
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class Feed {
  String feedback = '';
  int cnt;

  Feed(this.feedback, this.cnt);
}