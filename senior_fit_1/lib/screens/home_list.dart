import 'package:flutter/material.dart';
import 'package:senior_fit_1/screens/detail_screen.dart';

class Homelist extends StatefulWidget {
  const Homelist({Key? key}) : super(key: key);

  @override
  State<Homelist> createState() => _HomelistState();
}

class _HomelistState extends State<Homelist> {
  @override
  Widget build(BuildContext context) {
    double fontSizee = 28;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(250.0),
            child: Container(
              color: Colors.white,
              child: Image.asset('images/logo_appbar.png', fit: BoxFit.cover),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              const SizedBox(
                height: 50,
                child: Center(
                    child: Text(
                  '오늘의 운동을 선택해주세요!',
                  style: TextStyle(fontSize: 17),
                )),
              ),
              const Tile(
                image: 'images/man.png',
                description: '',
                action: '사이드 크런치',),
              Container(
                height: 10,
              ),
              const Tile(
                image: 'images/npush.png',
                description: '',
                action: '버드독',),
              Container(
                height: 10,
              ),
              const Tile(
                image: 'images/pushup.png',
                description: '',
                action: '푸시업',),
              Container(
                height: 10,
              ),
              const Tile(
                image: 'images/plank.png',
                description: '',
                action: '플랭크',),

            ],
          )),
    );
  }
}

class Tile extends StatelessWidget {
  final String action;
  final String image;
  final String description;

  const Tile(
      {Key? key,
      required this.image,
      required this.description,
      required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
      color: Colors.white,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>DetailScreen(
            action: action,
            description: description,
            image: image,
          ))
        );
      },
      child: SizedBox(
        height: 82,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              image,
              height: 40,
              width: 100,
              fit: BoxFit.contain,
            ),
            SizedBox(
              width: 200,
              child: Center(
                child: Text(
                  action,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
