import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:body_detection/models/pose.dart';
import 'package:body_detection/models/pose_landmark.dart';
import 'package:body_detection/models/pose_landmark_type.dart';
import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';

bool downPosition = false;
bool upPosition = true;
var reps = 0;

class PoseMaskPainter extends CustomPainter {
  final FlutterTts flutterTts = FlutterTts();

  PoseMaskPainter({
    required this.pose,
    required this.mask,
    required this.imageSize,
  }) {
    flutterTts.setLanguage('ko');
    flutterTts.setSpeechRate(0.4);
  }

  final Pose? pose;
  final ui.Image? mask;
  final Size imageSize;
  final pointPaint = Paint()..color = const Color.fromRGBO(255, 255, 255, 0.8);
  final leftPointPaint = Paint()..color = const Color.fromRGBO(223, 157, 80, 1);
  final rightPointPaint = Paint()
    ..color = const Color.fromRGBO(100, 208, 218, 1);
  final linePaint = Paint()
    ..color = const Color.fromRGBO(255, 255, 255, 0.9)
    ..strokeWidth = 3;
  final maskPaint = Paint()
    ..colorFilter = const ColorFilter.mode(
        Color.fromRGBO(0, 0, 255, 0.5), BlendMode.srcOut);

  @override
  void paint(Canvas canvas, Size size) {
    // _paintMask(canvas, size);
    _paintPose(canvas, size);
  }

  void _paintPose(Canvas canvas, Size size) {
    if (pose == null) return;
    final double hRatio =
    imageSize.width == 0 ? 1 : size.width / imageSize.width;
    final double vRatio =
    imageSize.height == 0 ? 1 : size.height / imageSize.height;

    offsetForPart(PoseLandmark part) =>
        Offset(part.position.x * hRatio, part.position.y * vRatio);

//     var myList = [];
// // calculate angles from three points
//     final angleLandmarksByType = {
//       for (final it in pose!.landmarks) it.type: it
//     };
//
//     for (final angle in angles) {
//       final leftShoulder = offsetForPart(angleLandmarksByType[angle[0]]!);
//       final leftElbow = offsetForPart(angleLandmarksByType[angle[1]]!);
//       final leftWrist = offsetForPart(angleLandmarksByType[angle[2]]!);
//       var hipAngles =
//           (atan2((leftWrist.dy - leftElbow.dy), (leftWrist.dx - leftElbow.dx)) -
//               atan2((leftShoulder.dy - leftElbow.dy),
//                   (leftShoulder.dx - leftElbow.dx)))
//               .abs() *
//               (180 / pi);
//       if (hipAngles > 180) {
//         hipAngles = 360 - hipAngles;
//       }
//
//       TextSpan span = TextSpan(
//         text: hipAngles.toStringAsFixed(2),
//         style: const TextStyle(
//           color: Color.fromARGB(255, 255, 0, 43),
//           fontSize: 18,
//           //shadows: [
//           // ui.Shadow(
//           //color: Color.fromRGBO(255, 255, 255, 1),
//           // offset: Offset(1, 1),
//           // blurRadius: 1,
//           // ),
//           // ],
//         ),
//       );
//       TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left);
//       tp.textDirection = TextDirection.ltr;
//       tp.layout();
//       tp.paint(canvas, leftElbow);
//
//       myList.add(hipAngles);
//       // print(hipAngles.toString());
//     }

    // Landmark connections
    final landmarksByType = {for (final it in pose!.landmarks) it.type: it};
    for (final connection in connections) {
      final point1 = offsetForPart(landmarksByType[connection[0]]!);
      final point2 = offsetForPart(landmarksByType[connection[1]]!);
      canvas.drawLine(point1, point2, linePaint);
    }

    for (final part in pose!.landmarks) {
      // Landmark points
      canvas.drawCircle(offsetForPart(part), 5, pointPaint);
      if (part.type.isLeftSide) {
        canvas.drawCircle(offsetForPart(part), 3, leftPointPaint);
      } else if (part.type.isRightSide) {
        canvas.drawCircle(offsetForPart(part), 3, rightPointPaint);
      }

      // Landmark labels
      // TextSpan span = TextSpan(
      ///text: part.type.toString().substring(16),
      // style: const TextStyle(
      //  color: Color.fromRGBO(0, 128, 255, 1),
      // fontSize: 10,
      // shadows: [
      // ui.Shadow(
      // color: Color.fromRGBO(255, 255, 255, 1),
      // offset: Offset(1, 1),
      // blurRadius: 1,
      // ),
      // ],
      // ),
      //);
      // TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left);
      // tp.textDirection = TextDirection.ltr;
      // tp.layout();
      // tp.paint(canvas, offsetForPart(part));
    }
    //Text(reps.toString());
    // inDownPosition(myList);
    // inUpPosition(myList);
    // print(reps);
    // print(downPosition);
    // print(upPosition);

  }

  @override
  bool shouldRepaint(PoseMaskPainter oldDelegate) {
    return oldDelegate.pose != pose ||
        oldDelegate.mask != mask ||
        oldDelegate.imageSize != imageSize;
  }

  // List<List<PoseLandmarkType>> get angles => [
  //   [
  //     PoseLandmarkType.leftShoulder,
  //     PoseLandmarkType.leftElbow,
  //     PoseLandmarkType.leftWrist,
  //   ],
  //   [
  //     PoseLandmarkType.rightHip,
  //     PoseLandmarkType.rightKnee,
  //     PoseLandmarkType.rightAnkle
  //   ],
  //   [
  //     PoseLandmarkType.rightShoulder,
  //     PoseLandmarkType.rightElbow,
  //     PoseLandmarkType.rightWrist,
  //   ],
  //   [
  //     PoseLandmarkType.leftHip,
  //     PoseLandmarkType.leftKnee,
  //     PoseLandmarkType.leftAnkle
  //   ],
  // ];

  List<List<PoseLandmarkType>> get connections => [
    [PoseLandmarkType.leftEar, PoseLandmarkType.leftEyeOuter],
    [PoseLandmarkType.leftEyeOuter, PoseLandmarkType.leftEye],
    [PoseLandmarkType.leftEye, PoseLandmarkType.leftEyeInner],
    [PoseLandmarkType.leftEyeInner, PoseLandmarkType.nose],
    [PoseLandmarkType.nose, PoseLandmarkType.rightEyeInner],
    [PoseLandmarkType.rightEyeInner, PoseLandmarkType.rightEye],
    [PoseLandmarkType.rightEye, PoseLandmarkType.rightEyeOuter],
    [PoseLandmarkType.rightEyeOuter, PoseLandmarkType.rightEar],
    [PoseLandmarkType.mouthLeft, PoseLandmarkType.mouthRight],
    [PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder],
    [PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip],
    [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip],
    [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow],
    [PoseLandmarkType.rightWrist, PoseLandmarkType.rightElbow],
    [PoseLandmarkType.rightWrist, PoseLandmarkType.rightThumb],
    [PoseLandmarkType.rightWrist, PoseLandmarkType.rightIndexFinger],
    [PoseLandmarkType.rightWrist, PoseLandmarkType.rightPinkyFinger],
    [PoseLandmarkType.leftHip, PoseLandmarkType.rightHip],
    [PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee],
    [PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee],
    [PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle],
    [PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle],
    [PoseLandmarkType.leftElbow, PoseLandmarkType.leftShoulder],
    [PoseLandmarkType.leftWrist, PoseLandmarkType.leftElbow],
    [PoseLandmarkType.leftWrist, PoseLandmarkType.leftThumb],
    [PoseLandmarkType.leftWrist, PoseLandmarkType.leftIndexFinger],
    [PoseLandmarkType.leftWrist, PoseLandmarkType.leftPinkyFinger],
    [PoseLandmarkType.leftAnkle, PoseLandmarkType.leftHeel],
    [PoseLandmarkType.leftAnkle, PoseLandmarkType.leftToe],
    [PoseLandmarkType.rightAnkle, PoseLandmarkType.rightHeel],
    [PoseLandmarkType.rightAnkle, PoseLandmarkType.rightToe],
    [PoseLandmarkType.rightHeel, PoseLandmarkType.rightToe],
    [PoseLandmarkType.leftHeel, PoseLandmarkType.leftToe],
    [PoseLandmarkType.rightIndexFinger, PoseLandmarkType.rightPinkyFinger],
    [PoseLandmarkType.leftIndexFinger, PoseLandmarkType.leftPinkyFinger],
  ];
  //
  // void inDownPosition(list) {
  //   if (list[0] > 70 && list[0] < 100 && upPosition == true) {
  //     downPosition = true;
  //     upPosition = false;
  //     flutterTts.speak('올려');
  //   }
  // }
  //
  // void inUpPosition(list) {
  //   if (list[0] > 170 && list[0] < 180) {
  //     if (downPosition == true) {
  //       reps = reps + 1;
  //       flutterTts.speak('내려');
  //     }
  //     downPosition = false;
  //     upPosition = true;
  //   }
  // }
}