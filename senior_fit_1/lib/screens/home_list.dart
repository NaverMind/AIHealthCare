import 'package:flutter/material.dart';
import 'package:senior_fit_1/screens/detail_screen.dart';

// class Homelist extends StatefulWidget {
//   const Homelist({Key? key}) : super(key: key);
//
//   @override
//   State<Homelist> createState() => _HomelistState();
// }
//
// class _HomelistState extends State<Homelist> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(250.0),
//         child: Container(
//           color: Colors.white,
//           child: Image.asset('images/logo_appbar.png', fit: BoxFit.cover),
//         ),
//       ),
//       body: ListView(
//         children: <Widget>[
//           Tile(
//             title: '플랭크',
//             subtitle: '가능한 최대 시간 동안 팔굽혀펴기와 비슷한 자세를 유지하는 것을 수반하는 등척성 체간근 근력 운동',
//             image: 'images/plank.png',
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class Tile extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final String image;
//
//   Tile({
//     required this.title,
//     required this.subtitle,
//     required this.image,
// });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(title),
//       leading: Image.asset(image),
//       onTap: () {},
//     );
//   }
// }

class Homelist extends StatefulWidget {
  const Homelist({Key? key}) : super(key: key);

  @override
  State<Homelist> createState() => _HomelistState();
}

class _HomelistState extends State<Homelist> {
  @override
  Widget build(BuildContext context) {
    double fontSizee = 28;
    return Container(
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
              Container(
                height: 50,
                child: const Center(
                    child: Text(
                  '오늘의 운동을 선택해주세요!',
                  style: TextStyle(fontSize: 17),
                )),
              ),
              const Tile(
                image: 'images/plank.png',
                description: '가능한 최대 시간 동안 팔굽혀펴기와 비슷한 자세를 유지하는 것을 수반하는 등척성 체간근 근력 운동',
                action: '플랭크',),
              Container(
                height: 10,
              ),
              Tile(
                image: 'images/pushup.png',
                description: '이것은 푸시업이다.',
                action: '푸시업',),
              Container(
                height: 10,
              ),
              Tile(
                image: 'images/npush.png',
                description: '이것은 무릎 푸시업',
                action: '무릎 푸시업',),
              Container(
                height: 10,
              ),
              Tile(
                  image: 'images/man.png',
                  description: '이것은 사이드 크런ㅌ치',
                  action: '사이드 크런치',),
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
      child: Container(
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
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
