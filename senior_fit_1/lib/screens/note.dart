import 'package:flutter/material.dart';
import 'package:senior_fit_1/screens/for_chart.dart';
import 'package:senior_fit_1/screens/note_detail.dart';

class Note extends StatefulWidget {
  const Note({Key? key}) : super(key: key);

  @override
  State<Note> createState() => _MyPageState();
}

class _MyPageState extends State<Note> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('운동 노트'),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 23),
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Image.asset(
                      'images/man.png',
                      height: 40,
                      width: 40,
                      fit: BoxFit.contain,
                    ),
                    const Text(
                      ' 사이드 크런치',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 3, 15, 10),
                child: Stack(children: [
                  LineChartSample2(
                    actionName: '사이드 크런치',
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(onPressed: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=>NoteDetail(
                            actionName: '사이드 크런치',
                          ))
                      );
                    }, icon: Icon(Icons.add_circle_outline,color: Color(0xff7209B7),)),
                  )
                ]),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Image.asset(
                      'images/pushup.png',
                      height: 40,
                      width: 40,
                      fit: BoxFit.contain,
                    ),
                    const Text(
                      ' 버드독',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 3, 15, 10),
                child: Stack(children: [
                  LineChartSample2(
                    actionName: '버드독',
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(onPressed: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=>NoteDetail(
                            actionName: '버드독',
                          ))
                      );
                    }, icon: Icon(Icons.add_circle_outline,color: Color(0xff7209B7),)),
                  )
                ]),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Image.asset(
                      'images/npush.png',
                      height: 40,
                      width: 40,
                      fit: BoxFit.contain,
                    ),
                    const Text(
                      ' 무릎 푸시업',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 3, 15, 10),
                child: Stack(children: [
                  LineChartSample2(
                    actionName: '무릎 푸시업',
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(onPressed: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=>NoteDetail(
                            actionName: '무릎 푸시업',
                          ))
                      );
                    }, icon: Icon(Icons.add_circle_outline,color: Color(0xff7209B7),)),
                  )
                ]),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Image.asset(
                      'images/plank.png',
                      height: 40,
                      width: 40,
                      fit: BoxFit.contain,
                    ),
                    const Text(
                      ' 플랭크',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 3, 15, 10),
                child: Stack(children: [
                  LineChartSample2(
                    actionName: '플랭크',
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(onPressed: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=>NoteDetail(
                            actionName: '플랭크',
                          ))
                      );
                    }, icon: Icon(Icons.add_circle_outline,color: Color(0xff7209B7),)),
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
