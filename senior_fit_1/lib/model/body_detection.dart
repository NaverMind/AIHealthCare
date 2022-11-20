import 'dart:math';
import 'package:body_detection/models/image_result.dart';
import 'package:body_detection/models/pose.dart';
import 'package:body_detection/models/body_mask.dart';
import 'package:body_detection/png_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:body_detection/body_detection.dart';
import 'package:permission_handler/permission_handler.dart';

import 'pose_mask_painter.dart';

class DetectPage extends StatefulWidget {
  const DetectPage({Key? key}) : super(key: key);

  @override
  State<DetectPage> createState() => _DetectPageState();
}

class _DetectPageState extends State<DetectPage> {
  Pose? _detectedPose;
  ui.Image? _maskImage;
  Image? _cameraImage;
  Size _imageSize = Size.zero;
  int currentMilliSecondsCompleteImage = DateTime.now().millisecondsSinceEpoch;
  int currentMilliSecondsPostTemp = DateTime.now().millisecondsSinceEpoch;
  int currentMilliSecondsCompletePose = DateTime.now().millisecondsSinceEpoch;
  int infTime= DateTime.now().millisecondsSinceEpoch;
  int dectTime= DateTime.now().millisecondsSinceEpoch;

  Future<void> _startCameraStream() async {
    final request = await Permission.camera.request();

    if (request.isGranted) {
      await BodyDetection.enablePoseDetection();
      print('☠️ enable~startCameraStream');
      await BodyDetection.startCameraStream(
        onFrameAvailable: _handleCameraImage,
        onPoseAvailable: (pose) {
          _handlePose(pose);
        },
      );
    }

    setState(() {
      _detectedPose = null;
      print('☠️ log: _detectedPose = null');
    });
  }

  Future<void> _stopCameraStream() async {
    await BodyDetection.stopCameraStream();

    setState(() {
      _cameraImage = null;
      _imageSize = Size.zero;
      print('☠️ log: _stopCameraStream');
    });
  }

  void _handleCameraImage(ImageResult result) {
    // Ignore callback if navigated out of the page.
    if (!mounted) return;

    // To avoid a memory leak issue.
    // https://github.com/flutter/flutter/issues/60160
    PaintingBinding.instance?.imageCache?.clear();
    PaintingBinding.instance?.imageCache?.clearLiveImages();
    print('☠️ log: _handleCameraImage');

    final image = Image.memory(
      result.bytes,
      gaplessPlayback: true,
      fit: BoxFit.contain,
    );

    currentMilliSecondsCompleteImage = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      _cameraImage = image;
      _imageSize = result.size;
    });
  }

  img_resize(pose_vector, real_width, real_height) {
    pose_vector = pose_vector.reshape(-1, 1);
    int x_max = 0;
    int y_max = 0;
    int x_min = 100000;
    int y_min = 100000;
    for (int i = 0; i < pose_vector.length; i++) {
      if (i % 2 == 0) {
        //x좌표
        if (x_max < pose_vector[i]) x_max = pose_vector[i];
        if (x_min > pose_vector[i]) x_min = pose_vector[i];
      } else {
        if (y_max < pose_vector[i]) y_max = pose_vector[i];
        if (y_min > pose_vector[i]) y_min = pose_vector[i];
      }
    }
    for (int i = 0; i < pose_vector.length; i++) {
      if (i % 2 == 0)
        pose_vector[i] -= x_min;
      else
        pose_vector[i] -= y_min;
    }
    for (int i = 0; i < pose_vector.length; i++) {
      if (i % 2 == 0) {
        //x좌표
        if (x_max < pose_vector[i]) x_max = pose_vector[i];
        if (x_min > pose_vector[i]) x_min = pose_vector[i];
      } else {
        if (y_max < pose_vector[i]) y_max = pose_vector[i];
        if (y_min > pose_vector[i]) y_min = pose_vector[i];
      }
    }

    int img_width = x_max - x_min;
    int img_height = y_max - y_min;

    int wid_portion = real_width / img_width;
    int hie_portion = real_height / img_height;

    for (int i = 0; i < pose_vector.length; i++) {
      if (i % 2 == 0)
        pose_vector[i] = pose_vector[i] * hie_portion;
      else
        pose_vector[i] = pose_vector[i] * wid_portion;
    }
    return pose_vector.reshape(6, -1);
  }

  normalization(x) {
    x = x.reshape(-1, 1);
    double minVal = 1000000.0;
    double maxVal = -1.0;
    for (double i in x) {
      if (x[i] > maxVal) maxVal = x[i];
      if (x[i] < minVal) minVal = x[i];
    }
    for (int i = 0; i < x.length; i++) {
      x[i] = (x[i] - minVal) / (maxVal - minVal);
    }
    return x.reshape(6, -1);
  }

  weightedDistanceMatching(poseVector1, poseVector2) {
    int vector1ConfidenceSum = poseVector1.length;
    double summation1 = 1 / vector1ConfidenceSum;
    double summation2 = 0.0;
    int count = 0;
    for (int i = 0; i < poseVector1.length; i++) {
      count++;
      double tempSum = (poseVector1[i] - poseVector2[i]).abs();
      summation2 += tempSum;
    }
    double summation = summation1 * summation2;
    return summation;
  }

  get_angle(p1, p2, p3) {
    // p1 = [x1,x2], p2 = [x1, x2], p3 = [x1,x2]
    double rad = atan2(p3[1] - p1[1], p3[0] - p1[0]) -
        atan2(p2[1] - p1[1], p2[0] - p1[0]);
    double deg = rad * (180 / pi);
    if (deg.abs() > 180)
      return deg = 360 - deg.abs();
    else
      return deg.abs();
  }

  final Map<String, List<String>> side_crunch = {
    "spine": [
      'PoseLandmarkType.midShoulder',
      "PoseLandmarkType.back",
      "PoseLandmarkType.midHip"
    ],
    "left_knee_elbow": [
      "PoseLandmarkType.leftElbow",
      "PoseLandmarkType.midHip",
      "PoseLandmarkType.leftKnee"
    ],
    "right_knee_elbow": [
      "PoseLandmarkType.rightElbow",
      "PoseLandmarkType.midHip",
      "PoseLandmarkType.rightKnee"
    ],
    "left_body_knee": [
      "PoseLandmarkType.nose",
      "PoseLandmarkType.midHip",
      "PoseLandmarkType.leftKnee"
    ],
    "right_body_knee": [
      "PoseLandmarkType.nose",
      "PoseLandmarkType.midHip",
      "PoseLandmarkType.rightKnee"
    ],
    "left_elbow": [
      "PoseLandmarkType.leftWrist",
      "PoseLandmarkType.leftElbow",
      "PoseLandmarkType.leftShoulder"
    ],
    "right_elbow": [
      "PoseLandmarkType.rightWrist",
      "PoseLandmarkType.rightElbow",
      "PoseLandmarkType.rightShoulder"
    ],
  };

  make_angle_list(keyPoints) {
    Map<String, List<double>> result = {};
    for (String i in side_crunch.keys) {
      result[i] = get_angle(keyPoints[side_crunch[i]![0]],
          keyPoints[side_crunch[i]![1]], keyPoints[side_crunch[i]![2]]);
    }
    return result;
  }

  make_point_list(keyPoints) {
    List<List<double>> point_list = [];
    for (String i in side_crunch.keys) {
      List<double> tmp = [];
      for (String j in side_crunch[i]!) {
        tmp.add(keyPoints[j][0]);
        tmp.add(keyPoints[j][1]);
      }
      point_list.add(tmp);
    }
    // 일단 200, 400으로 잡음
    point_list = img_resize(point_list, 200, 400);
    point_list = normalization(point_list);
    return point_list;
  }

  void _handlePose(Pose? pose) {
    // Ignore if navigated out of the page.
    if (!mounted) return;
    print('☠️ log: _handlePose');
    // 여기 pose 좌표 있음
    Map<String, List<double>> keyPoints = {};
    for (final part in pose!.landmarks) {
      print(part.type);
      print(
          '좌표 : X:${part.position.x} Y:${part.position.y} Z:${part.position.z}');
      keyPoints[part.type.toString()] = [part.position.x, part.position.y];
    }

    keyPoints['PoseLandmarkType.midShoulder'] = [
      ((keyPoints['PoseLandmarkType.rightShoulder']![0] +
              keyPoints['PoseLandmarkType.leftShoulder']![0]) /
          2),
      ((keyPoints['PoseLandmarkType.rightShoulder']![1] +
              keyPoints['PoseLandmarkType.leftShoulder']![1]) /
          2)
    ];
    keyPoints['PoseLandmarkType.midHip'] = [
      ((keyPoints['PoseLandmarkType.rightHip']![0] +
              keyPoints['PoseLandmarkType.leftHip']![0]) /
          2),
      ((keyPoints['PoseLandmarkType.rightHip']![1] +
              keyPoints['PoseLandmarkType.leftHip']![1]) /
          2)
    ];
    keyPoints['PoseLandmarkType.back'] = [
      ((keyPoints['PoseLandmarkType.midShoulder']![0] +
              keyPoints['PoseLandmarkType.midHip']![0]) /
          2),
      ((keyPoints['PoseLandmarkType.midShoulder']![1] +
              keyPoints['PoseLandmarkType.midHip']![1]) /
          2)
    ];

    ///// 정답 이미지 운동 좌표를 잘 받아왔다고 침 or 여기서는 angle배열이랑 좌표 정규화한 배열 return
    String exercise = '스탠딩 사이드 크런치';

    switch (exercise) {
      case '스탠딩 사이드 크런치':
        Map<String, List<double>> angle_list = make_angle_list(keyPoints);
        List<List<double>> point_list = make_point_list(keyPoints);
        break;
    }

    currentMilliSecondsCompletePose = DateTime.now().millisecondsSinceEpoch;

    setState(() {
      infTime =
          currentMilliSecondsCompletePose - currentMilliSecondsCompleteImage;
      dectTime = currentMilliSecondsCompletePose - currentMilliSecondsPostTemp;
      currentMilliSecondsPostTemp = currentMilliSecondsCompletePose;
      print('💡 InfTime: $infTime');
      _detectedPose = pose;
    });
  }

  Widget get _cameraDetectionView => SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ClipRect(
                child: CustomPaint(
                  child: _cameraImage,
                  foregroundPainter: PoseMaskPainter(
                    pose: _detectedPose,
                    mask: _maskImage,
                    imageSize: _imageSize,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  _stopCameraStream();
                  Navigator.pop(context);
                },
                child: const Text('돌아가기'),
              ),
              OutlinedButton(
                onPressed: () {},
                child: Text(
                  'InfTime: $infTime',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 25),
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                child: Text(
                  'DectTime: $dectTime',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 25),
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                child: Text(
                  'IO Time: ${dectTime - infTime}',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 25),
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                child: Text(
                  'DectTime: $dectTime',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 25),
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                child: Text(
                  'IO Time: ${dectTime - infTime}',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 25),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    _startCameraStream();
    print('☠️ log: initState');
  }

  @override
  void dispose() {
    super.dispose();
    _stopCameraStream();
    print('☠️ log: dispose');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _cameraDetectionView,
    );
  }
}
