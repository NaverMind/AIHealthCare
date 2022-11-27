import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:body_detection/models/pose.dart';
import 'package:body_detection/models/pose_landmark.dart';
import 'package:body_detection/models/pose_landmark_type.dart';
import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool downPosition = false;
bool upPosition = true;
var reps = 0;

class StandingSideCrunchPainter extends CustomPainter {
  final FlutterTts flutterTts = FlutterTts();

  // left와 right를 바꿈
  Map<String, List<double>> answer_side_crunch_right = {
    'PoseLandmarkType.nose': [0.5171129703521729, 0.15899354219436646],
    'PoseLandmarkType.leftEyeInner': [0.5183289051055908, 0.1349419355392456],
    'PoseLandmarkType.leftEye': [0.5255885720252991, 0.13036349415779114],
    'PoseLandmarkType.leftEyeOuter': [0.5334179401397705, 0.1256846785545349],
    'PoseLandmarkType.rightEyeInner': [0.5038018822669983, 0.14266902208328247],
    'PoseLandmarkType.rightEye': [0.5000702738761902, 0.14417356252670288],
    'PoseLandmarkType.rightEyeOuter': [0.4959765374660492, 0.14561492204666138],
    'PoseLandmarkType.leftEar': [0.5638001561164856, 0.11055099219083786],
    'PoseLandmarkType.rightEar': [0.5085387229919434, 0.13849219679832458],
    'PoseLandmarkType.mouthLeft': [0.5500407218933105, 0.16667233407497406],
    'PoseLandmarkType.mouthRight': [0.5274843573570251, 0.17537231743335724],
    'PoseLandmarkType.leftShoulder': [0.7035431861877441, 0.16348400712013245],
    'PoseLandmarkType.rightShoulder': [0.5058374404907227, 0.2248823046684265],
    'PoseLandmarkType.leftElbow': [0.7918897867202759, 0.05080733075737953],
    'PoseLandmarkType.rightElbow': [0.35992544889450073, 0.2699107527732849],
    'PoseLandmarkType.leftWrist': [0.6185818314552307, 0.07240039110183716],
    'PoseLandmarkType.rightWrist': [0.4448125660419464, 0.14904719591140747],
    'PoseLandmarkType.leftPinkyFinger': [
      0.5898570418357849,
      0.0747496485710144
    ],
    'PoseLandmarkType.rightPinkyFinger': [
      0.48234373331069946,
      0.12923142313957214
    ],
    'PoseLandmarkType.leftIndexFinger': [
      0.5949589014053345,
      0.08963793516159058
    ],
    'PoseLandmarkType.rightIndexFinger': [
      0.4958559274673462,
      0.13837534189224243
    ],
    'PoseLandmarkType.leftThumb': [0.6042082905769348, 0.09568983316421509],
    'PoseLandmarkType.rightThumb': [0.4911852777004242, 0.14683818817138672],
    'PoseLandmarkType.leftHip': [0.6202203035354614, 0.5036689043045044],
    'PoseLandmarkType.rightHip': [0.533719003200531, 0.4516322910785675],
    'PoseLandmarkType.leftKnee': [0.619498610496521, 0.736587405204773],
    'PoseLandmarkType.rightKnee': [0.3427906036376953, 0.32621967792510986],
    'PoseLandmarkType.leftAnkle': [0.5931094288825989, 0.9091367721557617],
    'PoseLandmarkType.rightAnkle': [0.21595825254917145, 0.5113396048545837],
    'PoseLandmarkType.leftHeel': [0.5707818865776062, 0.9311110377311707],
    'PoseLandmarkType.rightHeel': [0.2434459924697876, 0.5521597862243652],
    'PoseLandmarkType.leftToe': [0.6360167860984802, 0.9788834452629089],
    'PoseLandmarkType.rightToe': [0.0955314040184021, 0.5300770401954651]
  };

  Map<String, List<double>> answer_side_crunch_left = {
    'PoseLandmarkType.nose': [0.42637473344802856, 0.1530345380306244],
    'PoseLandmarkType.leftEyeInner': [0.44412294030189514, 0.13949140906333923],
    'PoseLandmarkType.leftEye': [0.4471409320831299, 0.14093738794326782],
    'PoseLandmarkType.leftEyeOuter': [0.4504188895225525, 0.1425165832042694],
    'PoseLandmarkType.rightEyeInner': [0.4270600378513336, 0.13200604915618896],
    'PoseLandmarkType.rightEye': [0.4195461869239807, 0.12715616822242737],
    'PoseLandmarkType.rightEyeOuter': [0.4107058644294739, 0.1213565468788147],
    'PoseLandmarkType.leftEar': [0.4385436177253723, 0.1436009705066681],
    'PoseLandmarkType.rightEar': [0.3736587166786194, 0.10791677236557007],
    'PoseLandmarkType.mouthLeft': [0.4116672873497009, 0.16775599122047424],
    'PoseLandmarkType.mouthRight': [0.3918655812740326, 0.15858334302902222],
    'PoseLandmarkType.leftShoulder': [0.43482357263565063, 0.2446928471326828],
    'PoseLandmarkType.rightShoulder': [0.19711549580097198, 0.16949363052845],
    'PoseLandmarkType.leftElbow': [0.6310123205184937, 0.2558884620666504],
    'PoseLandmarkType.rightElbow': [0.09575435519218445, 0.041953444480895996],
    'PoseLandmarkType.leftWrist': [0.48398736119270325, 0.1530769169330597],
    'PoseLandmarkType.rightWrist': [0.3037804067134857, 0.07519882917404175],
    'PoseLandmarkType.leftPinkyFinger': [
      0.4502747654914856,
      0.1240893304347992
    ],
    'PoseLandmarkType.rightPinkyFinger': [
      0.3433944582939148,
      0.08178502321243286
    ],
    'PoseLandmarkType.leftIndexFinger': [0.42852583527565, 0.1384158730506897],
    'PoseLandmarkType.rightIndexFinger': [
      0.33186647295951843,
      0.09348258376121521
    ],
    'PoseLandmarkType.leftThumb': [0.43582192063331604, 0.1559179127216339],
    'PoseLandmarkType.rightThumb': [0.31871986389160156, 0.09687435626983643],
    'PoseLandmarkType.leftHip': [0.41951826214790344, 0.4601353704929352],
    'PoseLandmarkType.rightHip': [0.3050236105918884, 0.513806164264679],
    'PoseLandmarkType.leftKnee': [0.640325129032135, 0.3295609652996063],
    'PoseLandmarkType.rightKnee': [0.31251072883605957, 0.7392155528068542],
    'PoseLandmarkType.leftAnkle': [0.7735593914985657, 0.5188997983932495],
    'PoseLandmarkType.rightAnkle': [0.3393845856189728, 0.9125605225563049],
    'PoseLandmarkType.leftHeel': [0.7550112009048462, 0.566190242767334],
    'PoseLandmarkType.rightHeel': [0.36122336983680725, 0.9333383440971375],
    'PoseLandmarkType.leftToe': [0.9223690032958984, 0.5348324775695801],
    'PoseLandmarkType.rightToe': [0.306747704744339, 0.9802437424659729]
  };

  final Map<String, List<String>> sideCrunch = {
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
      "PoseLandmarkType.leftHip",
      "PoseLandmarkType.leftKnee",
      "PoseLandmarkType.leftAnkle"
    ],
    "right_body_knee": [
      "PoseLandmarkType.rightHip",
      "PoseLandmarkType.rightKnee",
      "PoseLandmarkType.rightAnkle"
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
    "left_spine": [
      'PoseLandmarkType.leftShoulder',
      "PoseLandmarkType.back",
      "PoseLandmarkType.leftHip"
    ],
    "right_spine": [
      'PoseLandmarkType.rightShoulder',
      "PoseLandmarkType.back",
      "PoseLandmarkType.rightHip"
    ],
  };
  final Map<String, String> sideCrunchCommand = {
    "left_knee_elbow": "왼쪽 팔꿈치와 무릎을 더 붙이세요!",
    "right_knee_elbow": "오른쪽 팔꿈치와 무릎을 더 붙이세요!",
    "left_body_knee": "왼쪽 무릎을 조금 더 측면으로 옮겨주세요!",
    "right_body_knee": "오른쪽 무릎을 조금 더 측면으로 옮겨주세요!",
    "left_elbow": "왼손을 머리뒤에 위치해주세요!",
    "right_elbow": "오른손을 머리뒤에 위치해주세요!",
    "left_spine": "척추를 좀 더 펴주세요!",
    "right_spine": "척추를 좀 더 펴주세요!"
  };

  StandingSideCrunchPainter({
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
  final pointPaint = Paint()..color = const Color.fromRGBO(255, 0, 0, 0.8);
  final leftPointPaint = Paint()
    ..color = const Color.fromRGBO(223, 80, 80, 1.0);
  final rightPointPaint = Paint()
    ..color = const Color.fromRGBO(245, 10, 10, 1.0);
  final linePaint = Paint()
    ..color = const Color.fromRGBO(241, 0, 0, 0.9019607843137255)
    ..strokeWidth = 3;
  final maskPaint = Paint()
    ..colorFilter = const ColorFilter.mode(
        Color.fromRGBO(0, 0, 255, 0.5), BlendMode.srcOut);

  @override
  void paint(Canvas canvas, Size size) {
    // _paintMask(canvas, size);
    _paintPose(canvas, size);
    dealingPose(pose);
  }

  void _paintPose(Canvas canvas, Size size) {
    if (pose == null) return;

    final double hRatio =
        imageSize.width == 0 ? 1 : size.width / imageSize.width;
    final double vRatio =
        imageSize.height == 0 ? 1 : size.height / imageSize.height;

    offsetForPart(PoseLandmark part) =>
        Offset(part.position.x * hRatio, part.position.y * vRatio);

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
    }
    //
  }

  @override
  bool shouldRepaint(StandingSideCrunchPainter oldDelegate) {
    return oldDelegate.pose != pose ||
        oldDelegate.mask != mask ||
        oldDelegate.imageSize != imageSize;
  }

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

  imgResize(poseVector, real_width, real_height) {
    List<double> pose_vector = [];
    for (List<double> i in poseVector) {
      for (var j in i) pose_vector.add(j);
    }

    double x_max = 0;
    double y_max = 0;
    double x_min = 100000;
    double y_min = 100000;
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

    double img_width = x_max - x_min;
    double img_height = y_max - y_min;

    double wid_portion = real_width / img_width;
    double hie_portion = real_height / img_height;

    for (int i = 0; i < pose_vector.length; i++) {
      if (i % 2 == 0)
        pose_vector[i] = pose_vector[i] * hie_portion;
      else
        pose_vector[i] = pose_vector[i] * wid_portion;
    }
    var cnt = pose_vector.length / 6;
    List<List<double>> result = [];
    for (int i = 0; i < cnt; i++) {
      List<double> tmp = [];
      for (int j = 0; j < 6; j++) {
        tmp.add(pose_vector[i * 6 + j]);
      }
      result.add(tmp);
    }
    return result;
  }

  normalization(poseVector) {
    List<double> x = [];
    for (List<double> i in poseVector) {
      for (var j in i) x.add(j);
    }
    double minVal = 1000000.0;
    double maxVal = -1.0;
    for (int i = 0; i < x.length; i++) {
      if (x[i] > maxVal) maxVal = x[i];
      if (x[i] < minVal) minVal = x[i];
    }
    for (int i = 0; i < x.length; i++) {
      x[i] = (x[i] - minVal) / (maxVal - minVal);
    }
    var cnt = x.length / 6;
    List<List<double>> result = [];
    for (int i = 0; i < cnt; i++) {
      List<double> tmp = [];
      for (int j = 0; j < 6; j++) {
        tmp.add(x[i * 6 + j]);
      }
      result.add(tmp);
    }
    return result;
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
    // if (deg.abs() > 180) deg = 360 - deg.abs();
    if (deg.abs() > 180) deg = 360 - deg.abs();
    return deg.abs();
  }

  makeAngleList(keyPoints) {
    Map<String, double> result = {};
    for (String i in sideCrunch.keys) {
      // double tmp = get_angle(keyPoints[sideCrunch[i]![1]],
      //     keyPoints[sideCrunch[i]![0]], keyPoints[sideCrunch[i]![2]]);
      // result.addEntries([MapEntry(i, tmp)]);
      result[i] = get_angle(keyPoints[sideCrunch[i]![1]],
          keyPoints[sideCrunch[i]![0]], keyPoints[sideCrunch[i]![2]]);
    }
    return result;
  }

  makePointList(keyPoints) {
    List<List<double>> pointList = [];
    for (String i in sideCrunch.keys) {
      List<double> tmp = [];
      for (String j in sideCrunch[i]!) {
        tmp.add(keyPoints[j][0]);
        tmp.add(keyPoints[j][1]);
      }
      pointList.add(tmp);
    }
    // 일단 이미지 크기를 200, 400으로 잡음
    pointList = imgResize(pointList, 200, 400);
    pointList = normalization(pointList);
    return pointList;
  }

  Map<String, List<double>> add_angle(keyPoints) {
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
    return keyPoints;
  }

  dealingPose(pose) {
    Map<String, List<double>> keyPoints = {};
    if (pose == null) return;
    for (final part in pose!.landmarks) {
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
    //=-------------------------------------------------
    answer_side_crunch_right['PoseLandmarkType.midShoulder'] = [
      ((answer_side_crunch_right['PoseLandmarkType.rightShoulder']![0] +
              answer_side_crunch_right['PoseLandmarkType.leftShoulder']![0]) /
          2),
      ((answer_side_crunch_right['PoseLandmarkType.rightShoulder']![1] +
              answer_side_crunch_right['PoseLandmarkType.leftShoulder']![1]) /
          2)
    ];
    answer_side_crunch_right['PoseLandmarkType.midHip'] = [
      ((answer_side_crunch_right['PoseLandmarkType.rightHip']![0] +
              answer_side_crunch_right['PoseLandmarkType.leftHip']![0]) /
          2),
      ((answer_side_crunch_right['PoseLandmarkType.rightHip']![1] +
              answer_side_crunch_right['PoseLandmarkType.leftHip']![1]) /
          2)
    ];
    answer_side_crunch_right['PoseLandmarkType.back'] = [
      ((answer_side_crunch_right['PoseLandmarkType.midShoulder']![0] +
              answer_side_crunch_right['PoseLandmarkType.midHip']![0]) /
          2),
      ((answer_side_crunch_right['PoseLandmarkType.midShoulder']![1] +
              answer_side_crunch_right['PoseLandmarkType.midHip']![1]) /
          2)
    ];
    //=-------------------------------------------------
    answer_side_crunch_left['PoseLandmarkType.midShoulder'] = [
      ((answer_side_crunch_left['PoseLandmarkType.rightShoulder']![0] +
              answer_side_crunch_left['PoseLandmarkType.leftShoulder']![0]) /
          2),
      ((answer_side_crunch_left['PoseLandmarkType.rightShoulder']![1] +
              answer_side_crunch_left['PoseLandmarkType.leftShoulder']![1]) /
          2)
    ];
    answer_side_crunch_left['PoseLandmarkType.midHip'] = [
      ((answer_side_crunch_left['PoseLandmarkType.rightHip']![0] +
              answer_side_crunch_left['PoseLandmarkType.leftHip']![0]) /
          2),
      ((answer_side_crunch_left['PoseLandmarkType.rightHip']![1] +
              answer_side_crunch_left['PoseLandmarkType.leftHip']![1]) /
          2)
    ];
    answer_side_crunch_left['PoseLandmarkType.back'] = [
      ((answer_side_crunch_left['PoseLandmarkType.midShoulder']![0] +
              answer_side_crunch_left['PoseLandmarkType.midHip']![0]) /
          2),
      ((answer_side_crunch_left['PoseLandmarkType.midShoulder']![1] +
              answer_side_crunch_left['PoseLandmarkType.midHip']![1]) /
          2)
    ];
    //=-------------------------------------------------

    // answer_side_crunch_left = add_angle(answer_side_crunch_left);
    // answer_side_crunch_right = add_angle(answer_side_crunch_right);
    // keyPoints = add_angle(keyPoints);

    Map<String, double> angleList = makeAngleList(keyPoints);
    List<List<double>> pointList = makePointList(keyPoints);
    //정답 이미지 변수들 받아왔다고 치자
    Map<String, double> answerAngleList = {};
    List<List<double>> answerPointList = [];
    List<String> key = [];
    late int idx;
    if (angleList['left_body_knee']! >= 100 &&
        angleList['right_body_knee']! >= 100) {
      return;
    } else if (angleList['left_body_knee']! >= 100 &&
        angleList['right_body_knee']! <= 100) {
      answerAngleList = makeAngleList(answer_side_crunch_right);
      answerPointList = makePointList(answer_side_crunch_right);
      key = [
        "right_knee_elbow",
        "right_body_knee",
        "right_elbow",
        "right_spine"
      ];
      idx = 1;
      print("오른쪽 무릎");
    } else if (angleList['left_body_knee']! <= 100 &&
        angleList['right_body_knee']! >= 100) {
      answerAngleList = makeAngleList(answer_side_crunch_left);
      answerPointList = makePointList(answer_side_crunch_left);
      key = ["left_knee_elbow", "left_body_knee", "left_elbow", "left_spine"];
      idx = 0;
      print("왼쪽 무릎");
    }
    print(
        "왼쪽 무릎 각도 : ${angleList['left_body_knee']} // 오른쪽 무릎 각도 : ${angleList['right_body_knee']}");
    print("()()()()()()");
    List<double> score_list = [];
    double score_sum = 0.0;
    //75점을 넘기면 좋은 자세라고 판단.
    double threshold = 75;
    for (String i in key) {
      // 점수 계산(13주차 ppt 참고)
      print(
          "********************************************************************");
      print(
          '현재 부위 : ${i} // 정답 각도 : ${answerAngleList[i]} // 현재 각도 : ${angleList[i]} // 포즈 점수 : ${weightedDistanceMatching(pointList[idx], answerPointList![idx])}');
      //100점으로 환산 + 높은 값이 더 좋은 자세
      double score =
          ((answerAngleList[i]! - angleList[i]!.toDouble()).abs() / 180) * 50 +
              weightedDistanceMatching(pointList[idx], answerPointList[idx]) *
                  50;
      score = 100 - score;

      idx += 2;
      // sideCrunch변수에 운동에 중요한 부위를 순서대로 넣었다고 침.
      // score가 threshold보다 낮으면 피드백 구문 하나 출력 -> 끝내기
      print('Score : $score');
      score_list.add(score);
      score_sum += score;
    }
    getMax(score_list, score_sum, threshold, key, sideCrunchCommand);
    print(
        "-------------------------------------------------------------------------------------------------------------------------------------------");
  }

  /// 저장할 값 parameter에 넣어준다.
  Future<void> getMax(
      List<double> score_list,
      double score_sum,
      double threshold,
      List<String> key,
      Map<String, String> sideCrunchCommand) async {
    // SharedPreferences = 앱 전체에서 사용가능
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 현재 프레임 스코어 합산이 이전에 저장된 프레임 스코어 합산보다 클 경우 더 정확한 자세를 취한 프레임이므로 값 갱신.
    if (prefs.getDouble('score_sum')! < score_sum) {
      int idx = 0;
      // 현재 프레임에서 자세가 가장 안좋았던 부위(score의 값이 가장 낮은 부위)를 찾는 중
      for (int i = 1; i < score_list.length; i++) {
        if (score_list[idx] > score_list[i]) idx = i;
      }
      prefs.setDouble('score_sum', score_sum);
      prefs.setDouble('score', score_list[idx]);
      prefs.setString('part', key[idx]);
      // 스코어가 제일 낮은 값의 자세가 threshold보다 작거나 같으면 그 부위에 대한 피드백 해줌.
      if (score_list[idx] <= threshold)
        prefs.setString('feedback', sideCrunchCommand[key[idx]]!);
      // 스코어가 제일 낮은 값의 자세가 threshold보다 크면 모든 부위가 정확한 자세를 취한 것이므로 훌륭한 자세라고 함
      else
        prefs.setString('feedback', "훌륭한 자세입니다!");
    }
  }
}
