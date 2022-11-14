import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(child: Text('마이페이지')),
    );
  }
}
