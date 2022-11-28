import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final DateTime startTime;
  final actionname;

  const ResultPage(
      {Key? key, required this.actionname, required this.startTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.cancel_outlined,
            size: 40,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
