import 'package:flutter/material.dart';
import 'package:senior_fit_1/screens/for_chart.dart';

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
        title: Text('운동 노트'),
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 23),
        elevation: 0.0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    SizedBox(width: 12,),
                    Image.asset(
                      'images/plank.png',
                      height: 40,
                      width: 40,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      '플랭크',
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
                padding: const EdgeInsets.all(8.0),
                child: LineChartSample2(),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    SizedBox(width: 12,),
                    Image.asset(
                      'images/pushup.png',
                      height: 40,
                      width: 40,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      '푸시업',
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
                padding: const EdgeInsets.all(8.0),
                child: LineChartSample2(),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    SizedBox(width: 12,),
                    Image.asset(
                      'images/npush.png',
                      height: 40,
                      width: 40,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      '무릎 푸시업',
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
                padding: const EdgeInsets.all(8.0),
                child: LineChartSample2(),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    SizedBox(width: 12,),
                    Image.asset(
                      'images/man.png',
                      height: 40,
                      width: 40,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      '사이드 크런치',
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
                padding: const EdgeInsets.all(8.0),
                child: LineChartSample2(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
