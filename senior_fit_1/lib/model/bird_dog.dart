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

class BirdDogPainter extends CustomPainter {
  final FlutterTts flutterTts = FlutterTts();

  BirdDogPainter({
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
  final leftPointPaint = Paint()..color = const Color.fromRGBO(
      223, 80, 80, 1.0);
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
    Score();

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
  }

  @override
  bool shouldRepaint(BirdDogPainter oldDelegate) {
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

  normalization(pose_vector) {
    double minVal = 1000000.0;
    double maxVal = -1.0;
    for (int i=0;i<pose_vector.length;i++) {
      if (pose_vector[i] > maxVal) maxVal = pose_vector[i];
      if (pose_vector[i] < minVal) minVal = pose_vector[i];
    }
    for (int i = 0; i < pose_vector.length; i++) {
      pose_vector[i] = (pose_vector[i] - minVal) / (maxVal - minVal);
    }
    return pose_vector;
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


  imgResize(pose_vector, real_width, real_height) {
    //pose_vector = pose_vector.reshape(-1, 1);
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
    return pose_vector;
  }

  late List<double> scores;

  make_pose_list(){
    if (pose == null) return;

    Map pose_dict = {
      'NOSE': {
        'x': pose!.landmarks[0].position.x,'y': pose!.landmarks[0].position.y
      },
      'RIGHT_ANKLE': {
        'x': pose!.landmarks[2].position.x,'y': pose!.landmarks[2].position.y
      },
      'RIGHT_KNEE': {
        'x': pose!.landmarks[3].position.x,'y': pose!.landmarks[3].position.y
      },
      'LEFT_KNEE': {
        'x': pose!.landmarks[4].position.x,'y': pose!.landmarks[4].position.y
      },
      'RIGHT_WRIST': {
        'x': pose!.landmarks[5].position.x,'y': pose!.landmarks[5].position.y
      },
      'LEFT_ELBOW': {
        'x': pose!.landmarks[7].position.x,'y': pose!.landmarks[7].position.y
      },
      'RIGHT_ELBOW': {
        'x': pose!.landmarks[9].position.x,'y': pose!.landmarks[9].position.y
      },
      'LEFT_ANKLE': {
        'x': pose!.landmarks[10].position.x,'y': pose!.landmarks[10].position.y
      },
      'RIGHT_HIP': {
        'x': pose!.landmarks[22].position.x,'y': pose!.landmarks[22].position.y
      },
      'LEFT_HIP': {
        'x': pose!.landmarks[26].position.x,'y': pose!.landmarks[26].position.y
      },
      'LEFT_WRIST': {
        'x': pose!.landmarks[29].position.x,'y': pose!.landmarks[29].position.y
      },
      'LEFT_SHOULDER': {
        'x': pose!.landmarks[30].position.x,'y': pose!.landmarks[30].position.y
      },
      'RIGHT_SHOULDER': {
        'x': pose!.landmarks[32].position.x,'y': pose!.landmarks[32].position.y
      }
    };
    print(pose_dict);
    return pose_dict;
  }

  dif_angle(cur_con,real_con) {
    double ret1 = get_angle([cur_con[2],cur_con[3]], [cur_con[4],cur_con[5]], [cur_con[0],cur_con[1]]);
    double ret2 = get_angle([real_con[2],real_con[3]], [real_con[4],real_con[5]], [real_con[0],real_con[1]]);
    return (ret1 - ret2).abs();
  }

  make_posevector(){
    Map pose_dict = make_pose_list();
    List<double> pose_vector_con1 = [
      pose_dict['LEFT_HIP']['x'],pose_dict['LEFT_HIP']['y'],
      pose_dict['LEFT_SHOULDER']['x'],pose_dict['LEFT_SHOULDER']['y'],
      pose_dict['LEFT_ELBOW']['x'],pose_dict['LEFT_ELBOW']['y']];
    List<double> pose_vector_con2 = [
      pose_dict['RIGHT_ELBOW']['x'],pose_dict['RIGHT_ELBOW']['y'],
      pose_dict['RIGHT_SHOULDER']['x'],pose_dict['RIGHT_SHOULDER']['y'],
      pose_dict['RIGHT_HIP']['x'],pose_dict['RIGHT_HIP']['y']];
    List<double> pose_vector_con3 = [
      pose_dict['LEFT_SHOULDER']['x'],pose_dict['LEFT_SHOULDER']['y'],
      pose_dict['LEFT_HIP']['x'],pose_dict['LEFT_HIP']['y'],
      pose_dict['LEFT_KNEE']['x'],pose_dict['LEFT_KNEE']['y']];
    List<double> pose_vector_con4 = [
      pose_dict['RIGHT_HIP']['x'],pose_dict['LEFT_HIP']['y'],
      pose_dict['RIGHT_KNEE']['x'],pose_dict['RIGHT_KNEE']['y'],
      pose_dict['RIGHT_ANKLE']['x'],pose_dict['RIGHT_ANKLE']['y']];
    List<double> pose_vector_con5 = [
      pose_dict['RIGHT_SHOULDER']['x'],pose_dict['RIGHT_SHOULDER']['y'],
      pose_dict['RIGHT_HIP']['x'],pose_dict['RIGHT_HIP']['y'],
      pose_dict['RIGHT_KNEE']['x'],pose_dict['RIGHT_KNEE']['y']];

    List<double> real_con1 = [0.0, 0.17286392720946916, 0.6603482018800974, 0.03438576300685471, 1.0, 0.0];
    List<double> real_con2 = [1.0, 0.6243940626548732, 0.9995731397746898, 0.0, 0.0, 0.11829068609182228];
    List<double> real_con3 = [0.6861641712607421, 0.0, 0.0, 0.31393207508105675, 0.004558371933265137, 1.0];
    List<double> real_con4 = [1.0, 0.0383652712869501, 0.4764838210092951, 0.09364030136641684, 0.0, 0.0];
    List<double> real_con5 = [1.0, 0.0, 0.44841388894524653, 0.04432492096112053, 0.0, 0.07672047145544082];

    pose_vector_con1 = imgResize(pose_vector_con1, 600, 200);
    pose_vector_con2 = imgResize(pose_vector_con2, 600, 200);
    pose_vector_con3 = imgResize(pose_vector_con3, 600, 200);
    pose_vector_con4 = imgResize(pose_vector_con4, 600, 200);
    pose_vector_con5 = imgResize(pose_vector_con5, 600, 200);

    pose_vector_con1 = normalization(pose_vector_con1);
    pose_vector_con2 = normalization(pose_vector_con2);
    pose_vector_con3 = normalization(pose_vector_con3);
    pose_vector_con4 = normalization(pose_vector_con4);
    pose_vector_con5 = normalization(pose_vector_con5);

    double ang_1 = dif_angle(pose_vector_con1,real_con1);
    double ang_2 = dif_angle(pose_vector_con2,real_con2);
    double ang_3 = dif_angle(pose_vector_con3,real_con3);
    double ang_4 = dif_angle(pose_vector_con4,real_con4);
    double ang_5 = dif_angle(pose_vector_con5,real_con5);

    double ans_con1 = weightedDistanceMatching(pose_vector_con1,real_con1);
    double ans_con2 = weightedDistanceMatching(pose_vector_con2,real_con2);
    double ans_con3 = weightedDistanceMatching(pose_vector_con3,real_con3);
    double ans_con4 = weightedDistanceMatching(pose_vector_con4,real_con4);
    double ans_con5 = weightedDistanceMatching(pose_vector_con5,real_con5);

    double score1 = ans_con1*50 + ang_1;
    double score2 = ans_con2*50 + ang_2;
    double score3 = ans_con3*50 + ang_3;
    double score4 = ans_con4*50 + ang_4;
    double score5 = ans_con5*50 + ang_5;

    List<double> score_list = [score1,score2,score3,score4,score5];

    return score_list;


  }

  make_score(){
    //imgResize(,200,600)
  }
  Score() {
    if (pose == null) return;
    double? score;

    List<double> score_list = make_posevector();
    double min = 100000;
    int min_score = 0;

    double threshold = 20;
    bool exist_feedback = false;
    double score_sum = 0;
    for(int i= 0;i<5;i++){
      if(score_list[i]<min){
        min = score_list[i];
        min_score = i;
        score_sum += score_list[i];
        if(score_list[i]>threshold) exist_feedback = true;
      }
    }

    String feedback = "훌륭한 자세입니다!";
    String part = "NONE";
    int feedback_score = -1;
    //feedback
    if(min_score == 0){
      feedback = "왼쪽 팔을 앞으로 쭉 뻗어주세요!";
      part = "왼쪽 팔";
    }
    else if(min_score == 1){
      feedback = "오른쪽 손을 어깨 아래에 놓아주세요!";
      part = "오른쪽 팔";
    }
    else if(min_score == 2){
      feedback = "왼쪽 다리는 지면과 90도로 만들어주세요!";
      part = "왼쪽 다리";
    }
    else if(min_score == 3){
      feedback = "오른쪽 다리를 뒤로 쭉 뻗어주세요!";
      part = "오른쪽 다리";
    }
    else if(min_score == 4){
      feedback = "오른쪽 다리를 엉덩이 높이까지 들어주세요!";
      part = "오른쪽 다리";
    }

    if(exist_feedback==false){
      feedback = "훌륭한 자세입니다!";
    }

    getMax(min, score_sum, threshold, part, feedback);

  }

  Future<void> getMax(
      double min_score,
      double score_sum,
      double threshold,
      String part,
      String feedback) async {
    // SharedPreferences = 앱 전체에서 사용가능
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 현재 프레임 스코어 합산이 이전에 저장된 프레임 스코어 합산보다 클 경우 더 정확한 자세를 취한 프레임이므로 값 갱신.
    if (prefs.getDouble('score_sum')! < score_sum) {
      /*
      score_sum = 0.12;
      min_score = 0.12;
      part = "knee";
      feedback = "팔을 펴주세요!";

       */
      prefs.setDouble('score_sum', score_sum); //높은 프레임의 전체 점수 (100점환산)
      prefs.setDouble('score', min_score); //피드백 부위의 점수
      prefs.setString('part', part);//부위명
      prefs.setString('feedback', feedback);

    }
  }
}