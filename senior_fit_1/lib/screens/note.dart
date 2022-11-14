import 'package:flutter/material.dart';

class Note extends StatefulWidget {
  const Note({Key? key}) : super(key: key);

  @override
  State<Note> createState() => _MyPageState();
}

class _MyPageState extends State<Note> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(child: Text('운동노트')),
    );
  }
}
