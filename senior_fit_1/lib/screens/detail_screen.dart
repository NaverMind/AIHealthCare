import 'package:flutter/material.dart';
import 'package:senior_fit_1/screens/player.dart';

import '../model/body_detection.dart';

class DetailScreen extends StatelessWidget {
  final String action;
  final String image;
  final String description;

  var imagee = {
    '플랭크': 'images/plank_detail.png',
    '푸시업': 'images/pushup.jpg',
    '무릎 푸시업': 'images/kneepushup.jpg',
    '사이드 크런치': 'images/standingside.png'
  };

  DetailScreen({
    required this.image,
    required this.description,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(250.0),
          child: Container(
            color: Colors.white,
            child: Image.asset(imagee[action]!, fit: BoxFit.cover),
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
                  action,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 2, 0, 30),
                  child: Text(
                    description,
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
              actionname: action,
            ),
            Container(
              height: 10,
            ),
            Tile(
              image: 'images/iconFix.png',
              description: '나의 자세를 실시간으로 코칭 받아 보세요!',
              action: '자세 교정받기',
              isCamera: true,
              actionname: action,
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

  final bool isCamera;
  var youtubelink = {
    '플랭크': 'VPZvWMXNfwk',
    '푸시업': '_m31z7To0Ko',
    '무릎 푸시업': '_m31z7To0Ko',
    '사이드 크런치': 'GjaYv6vaqu8'
  };

  Tile(
      {Key? key,
      required this.actionname,
      required this.image,
      required this.description,
      required this.action,
      required this.isCamera})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
      color: Colors.white,
      onPressed: () {
        if (isCamera) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const DetectPage()));
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
