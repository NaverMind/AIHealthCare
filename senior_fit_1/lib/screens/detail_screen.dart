import 'package:flutter/material.dart';
import 'package:senior_fit_1/screens/player.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/body_detection.dart';

class DetailScreen extends StatefulWidget {
  final String action;
  final String image;
  final String description;

  DetailScreen({
    required this.image,
    required this.description,
    required this.action,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  var imagee = {
    '플랭크': 'images/plank_detail.png',
    '푸시업': 'images/pushup.jpg',
    '버드독': 'images/kneepushup.jpg',
    '사이드 크런치': 'images/standingside.png'
  };

  var tutorialYoutubelink = {
    '플랭크': 'VPZvWMXNfwk',
    '푸시업': '_m31z7To0Ko',
    '버드독': 'SfjFnlwBwgE',
    '사이드 크런치': 'GjaYv6vaqu8'
  };

  int newValue = 8;

  late SharedPreferences prefs;

  _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      newValue = prefs.getInt('${widget.action}counter') ?? 9;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPrefs();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.2,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          toolbarHeight: 250,
          leading: Column(
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
          flexibleSpace: PreferredSize(
            preferredSize: const Size.fromHeight(250.0),
            child: SafeArea(
              child: Container(
                color: Colors.white,
                child: Image.asset(imagee[widget.action]!, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '운동종목',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                Text(
                  widget.action,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 2, 0, 30),
                  child: Text(
                    widget.description,
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            Tile(
              image: 'images/iconLearn.png',
              description: '자세를 교정받기 전 정확한 운동 자세를 배워보세요!',
              action: '운동 배우기',
              isCamera: false,
              actionname: widget.action,
              counter: 0,
            ),
            Container(
              height: 10,
            ),
            Tile(
              image: 'images/iconFix.png',
              description: '나의 자세를 실시간으로 코칭 받아 보세요!',
              action: '자세 교정받기',
              isCamera: true,
              actionname: widget.action,
              counter: newValue,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Player(
                                tutorialYoutubelink[widget.action]!,
                                widget.action)));
                  },
                  child: Text(
                    '튜토리얼',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5);
                        return Colors.white
                            .withOpacity(0.5); // Use the component's default.
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5);
                        return Colors.black; // Use the component's default.
                      },
                    ),
                    padding: MaterialStateProperty.resolveWith<EdgeInsets?>(
                      (Set<MaterialState> states) {
                        return EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 30); // Use the component's default.
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      height: 90,
                      width: 50,
                      child: NumberPicker(
                        selectedTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                        textStyle: TextStyle(color: Colors.grey),
                        value: newValue,
                        itemHeight: 30,
                        minValue: 1,
                        maxValue: 100,
                        onChanged: (value) => setState(() => newValue = value),
                      ),
                    ),
                    Text(
                      '세트',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}

class Tile extends StatelessWidget {
  final String action;
  final String image;
  final String description;
  final String actionname;
  final int counter;

  final bool isCamera;
  var youtubelink = {
    '플랭크': 'VPZvWMXNfwk',
    '푸시업': '_m31z7To0Ko',
    '버드독': 'SfjFnlwBwgE',
    '사이드 크런치': 'GjaYv6vaqu8'
  };

  Tile(
      {Key? key,
      required this.actionname,
      required this.image,
      required this.description,
      required this.action,
      required this.isCamera,
      required this.counter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
      color: Colors.white,
      onPressed: () async {
        if (isCamera) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('${actionname}counter', counter);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetectPage(
                    actionname: actionname,
                    counter: counter,
                  )));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Player(youtubelink[actionname]!, actionname)));
        }
      },
      child: Container(
        height: 140,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              image,
              height: 50,
              width: 90,
              fit: BoxFit.contain,
            ),
            SizedBox(
              width: 190,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    action,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
