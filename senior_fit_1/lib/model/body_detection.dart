import 'dart:io';
import 'dart:typed_data';
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
  late int infTime;
  late int dectTime;

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

//#############################################################################
// 언니가 준 코드 python -> dart로 바꾼 것
  //0과 1사이로 정규화해서 좌표값 출력해줌
  final Map<String, List<double>> answer_side_crunch_left = {
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

  final Map<String, List<double>> answer_side_crunch_right = {
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

  final Map<String, List<double>> answer_push_up = {
    'PoseLandmarkType.nose': [0.17383897304534912, 0.5315790772438049],
    'PoseLandmarkType.leftEyeInner': [0.15820586681365967, 0.5126584768295288],
    'PoseLandmarkType.leftEye': [0.1581692099571228, 0.5087916254997253],
    'PoseLandmarkType.leftEyeOuter': [0.158083975315094, 0.5056026577949524],
    'PoseLandmarkType.rightEyeInner': [0.15812471508979797, 0.5135710835456848],
    'PoseLandmarkType.rightEye': [0.15811008214950562, 0.5098704695701599],
    'PoseLandmarkType.rightEyeOuter': [0.158117413520813, 0.5056143999099731],
    'PoseLandmarkType.leftEar': [0.16536074876785278, 0.47831618785858154],
    'PoseLandmarkType.rightEar': [0.16642498970031738, 0.4765322208404541],
    'PoseLandmarkType.mouthLeft': [0.18792566657066345, 0.5282084941864014],
    'PoseLandmarkType.mouthRight': [0.1887476146221161, 0.5278042554855347],
    'PoseLandmarkType.leftShoulder': [0.25078076124191284, 0.5118459463119507],
    'PoseLandmarkType.rightShoulder': [0.2801225185394287, 0.4992329478263855],
    'PoseLandmarkType.leftElbow': [0.24178721010684967, 0.7223902344703674],
    'PoseLandmarkType.rightElbow': [0.27692610025405884, 0.6807739734649658],
    'PoseLandmarkType.leftWrist': [0.15218418836593628, 0.6940330266952515],
    'PoseLandmarkType.rightWrist': [0.1632312834262848, 0.6849313974380493],
    'PoseLandmarkType.leftPinkyFinger': [
      0.1267264485359192,
      0.7065823078155518
    ],
    'PoseLandmarkType.rightPinkyFinger': [
      0.13501209020614624,
      0.6976184844970703
    ],
    'PoseLandmarkType.leftIndexFinger': [
      0.12602433562278748,
      0.6784172654151917
    ],
    'PoseLandmarkType.rightIndexFinger': [
      0.1331237554550171,
      0.6730511784553528
    ],
    'PoseLandmarkType.leftThumb': [0.13493236899375916, 0.670667290687561],
    'PoseLandmarkType.rightThumb': [0.14319634437561035, 0.6638280153274536],
    'PoseLandmarkType.leftHip': [0.505448043346405, 0.5763669610023499],
    'PoseLandmarkType.rightHip': [0.5098627209663391, 0.5585488080978394],
    'PoseLandmarkType.leftKnee': [0.6932380795478821, 0.605292797088623],
    'PoseLandmarkType.rightKnee': [0.6941864490509033, 0.5893735289573669],
    'PoseLandmarkType.leftAnkle': [0.8683022260665894, 0.6348528265953064],
    'PoseLandmarkType.rightAnkle': [0.8596028089523315, 0.6341402530670166],
    'PoseLandmarkType.leftHeel': [0.8855698108673096, 0.6148566603660583],
    'PoseLandmarkType.rightHeel': [0.8820675015449524, 0.6211080551147461],
    'PoseLandmarkType.leftToe': [0.85872483253479, 0.7344816327095032],
    'PoseLandmarkType.rightToe': [0.8546719551086426, 0.727775514125824]
  };

  imgResize(pose_vector, real_width, real_height) {
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

//#############################################################################

//------------------------------------------------------------------------------
// pose feedback을 위해 짠 코드
  // 사이드 크런치 처리하기위한 변수. 각 부위별 어떤 좌표를 참조해야하는지 map형식으로 넣어둠.
  final Map<String, List<String>> sideCrunch = {
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

  // 사이드 크런치 피드백을 위한 변수.
  final Map<String, String> sideCrunchCommand = {
    "spine": "척추를 좀 더 펴주세요!",
    "left_knee_elbow": "왼쪽 팔꿈치와 무릎을 더 붙이세요!",
    "right_knee_elbow": "오른쪽 팔꿈치와 무릎을 더 붙이세요!",
    "left_body_knee": "왼쪽 무릎을 조금 더 측면으로 옮겨주세요!",
    "right_body_knee": "오른쪽 무릎을 조금 더 측면으로 옮겨주세요!",
    "left_elbow": "왼손을 머리뒤에 위치해주세요!",
    "right_elbow": "오른손을 머리뒤에 위치해주세요!"
  };

  // 각 부위별로 각도를 구해서 부위별 이름 (ex.spine) 에 map 형식으로 각도 match
  makeAngleList(keyPoints, exercise) {
    Map<String, double> result = {};
    switch (exercise) {
      case "스탠딩 사이드 크런치":
        for (String i in sideCrunch.keys) {
          result[i] = get_angle(keyPoints[sideCrunch[i]![0]],
              keyPoints[sideCrunch[i]![1]], keyPoints[sideCrunch[i]![2]]);
        }
        break;
    }
    return result;
  }

  // 각 부위별로 필요한 keypoints들 넣어줌. (ex. spine이면 어깨, 등, 엉덩이 xy좌표를 1차원 배열로 넣어줌)
  makePointList(keyPoints, exercise) {
    List<List<double>> pointList = [];
    switch (exercise) {
      case "스탠딩 사이드 크런치":
        for (String i in sideCrunch.keys) {
          List<double> tmp = [];
          for (String j in sideCrunch[i]!) {
            tmp.add(keyPoints[j][0]);
            tmp.add(keyPoints[j][1]);
          }
          pointList.add(tmp);
        }
        break;
    }
    // 일단 이미지 크기를 200, 400으로 잡음
    pointList = imgResize(pointList, 200, 400);
    pointList = normalization(pointList);
    return pointList;
  }

  // pose score내는 함수
  dealingPose(pose) {
    // 각 부위별x,y좌표를 담은 map변수
    Map<String, List<double>> keyPoints = {};
    for (final part in pose!.landmarks) {
      keyPoints[part.type.toString()] = [part.position.x, part.position.y];
    }
    // blazePoze에는 어깨, 등, 엉덩이가 없거나 있어도 왼쪽 오른쪽으로 있기때문에 어깨 중간, 엉덩이 중간, 등 좌표를 추가해줌
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
    ///// angle배열이랑 좌표 정규화한 배열 return
    String exercise = '스탠딩 사이드 크런치';
    Map<String, double> angleList = makeAngleList(keyPoints, exercise);
    List<List<double>> pointList = makePointList(keyPoints, exercise);

    //정답 이미지 변수들 받아왔다고 치자
    Map<String, double> answerAngleList;
    List<List<double>> answerPointList;
    //밑 180.0이랑 정답 운동 포즈 좌표 [1,1,1,1,1,1]은 임의로 정한 정답 값
    int idx = 0;
    for (var i in keyPoints.keys) {
      // 점수 계산(13주차 ppt 참고)
      double score = ((180 - angleList[i]!).abs() / 180) * 0.5 +
          weightedDistanceMatching(pointList[idx++], [1, 1, 1, 1, 1, 1]) * 0.5;
      // threshold는 실험하면서 추후 조정
      double threshold = 0.5;
      if (score > threshold) {
        // sideCrunch변수에 운동에 중요한 부위를 순서대로 넣었다고 침.
        // score가 threshold보다 낮으면 피드백 구문 하나 출력 -> 끝내기
        print(sideCrunchCommand[i]);
        break;
      }
    }
  }

//------------------------------------------------------------------------------

  void _handlePose(Pose? pose) {
    // Ignore if navigated out of the page.
    if (!mounted) return;
    print('☠️ log: _handlePose');
    // 여기 pose 좌표 있음
    for (final part in pose!.landmarks) {
      print(part.type);
      print(
          '좌표 : X:${part.position.x} Y:${part.position.y} Z:${part.position.z}');
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
