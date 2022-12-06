import 'dart:async';

import 'package:body_detection/models/image_result.dart';
import 'package:body_detection/models/pose.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:body_detection/body_detection.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:senior_fit_1/database/drift_database.dart';
import 'package:senior_fit_1/model/standing_side_crunch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/result_page.dart';
import 'pose_mask_painter.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:senior_fit_1/model/bird_dog.dart';

class DetectPage extends StatefulWidget {
  final String actionname;
  final int counter;

  DetectPage({
    Key? key,
    required this.actionname,
    required this.counter,
  }) : super(key: key);

  @override
  State<DetectPage> createState() => _DetectPageState();
}

class _DetectPageState extends State<DetectPage> {
  late SharedPreferences prefs;

  Pose? _detectedPose;
  ui.Image? _maskImage;
  Image? _cameraImage;
  Size _imageSize = Size.zero;
  int currentMilliSecondsCompleteImage = DateTime.now().millisecondsSinceEpoch;
  int currentMilliSecondsPostTemp = DateTime.now().millisecondsSinceEpoch;
  int currentMilliSecondsCompletePose = DateTime.now().millisecondsSinceEpoch;
  int infTime = DateTime.now().millisecondsSinceEpoch;
  int dectTime = DateTime.now().millisecondsSinceEpoch;
  bool isInCamera = false;
  int isInCameraCnt = 0;
  final FlutterTts flutterTts = FlutterTts();
  late Stream<bool> timerStream;
  late StreamSubscription timerStreamSubscription;
  bool isActiveStart = false;
  bool isInFeedbackTime = false;
  late DateTime startTime;
  int thisCounter = 0;

  /// 실험 변수 기본 값..수정 x
  int readyBeepTermMillisecond = 1000;
  int readyBeepCount = 3;
  int inScoringTimeMillisecond = 1000;
  double ttsSetSpeechRate = 0.5;
  bool youziSoundOn = true;
  bool jongRoSoundOn = true;
  bool breakTimeOn = false;
  int breakTimeMillisecond = 0;

  /// 실험 변수 설정=======================================
   void settingForExp() {
    if (widget.actionname == '사이드 크런치') {
      readyBeepTermMillisecond = 500;
      readyBeepCount = 3;
      inScoringTimeMillisecond = 500;
      ttsSetSpeechRate = 0.5;
      youziSoundOn = false;
      jongRoSoundOn = false;
      breakTimeOn = true;
      breakTimeMillisecond = 2500;
    }
    else if(widget.actionname == '버드독'){
      readyBeepTermMillisecond = 500;
      readyBeepCount = 3;
      inScoringTimeMillisecond = 7000;
      ttsSetSpeechRate = 0.5;
      youziSoundOn = true;
      jongRoSoundOn = true;
      breakTimeOn = true;
      breakTimeMillisecond = 10000;
    }
  }

  /// ===================================================

  _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('feedback', '');
    prefs.setString('part', '');
    prefs.setDouble('score_sum', 0.0);
  }

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    settingForExp();
    DateTime dayTime = DateTime(
      DateTime.now().year,
      DateTime.now().add(const Duration(days: -5)).month,
      DateTime.now().add(const Duration(days: -5)).day,
    );

    startTime = DateTime.now();
    _startCameraStream();
    // print('☠️ log: initState');
    flutterTts.setLanguage('ko');
    flutterTts.setSpeechRate(ttsSetSpeechRate);
    timerStream = _startTimerStream();
    timerStreamSubscription = timerStream.listen((event) async {
      if (event) {
        FlutterBeep.beep(true);
        setState(() {
          isInFeedbackTime = true;
        });
        if (youziSoundOn) {
          flutterTts.speak('유지');
        }
      } else {
        if (isInFeedbackTime) {
          if (jongRoSoundOn) {
            flutterTts.speak('종료');
          }
          List<String>? feedbackStr = prefs.getString('feedback')?.split('.');
          if (feedbackStr![0] != '') {
            flutterTts.speak(feedbackStr![0]+feedbackStr![1]);
            thisCounter++;
            // TODO: db에 저장 필요.
            // active name, score(prefs), feedback(prefs), part(prefs), 운동 시작 날짜+시간
            final keyValue = await GetIt.I<LocalDatabase>().createFeedbackScore(
              FeedbackScoresCompanion(
                activeName: Value(widget.actionname),
                startTime: Value(startTime),
                feedback: Value(prefs.getString('feedback')!.split('.')[0]),
                part: Value(prefs.getString('part')!),
                score: Value(prefs.getDouble('score_sum')!.toInt()),
                createdAt: Value(dayTime),
              ),
            );
            print('👍👍👍👍 database : $keyValue 저장 완료');
            prefs.setString('feedback', '');
            prefs.setString('part', '');
            prefs.setDouble('score_sum', 0.0);
          }
          setState(() {
            isInFeedbackTime = false;
          });
        } else {
          FlutterBeep.beep(false);
        }
      }

    });
  }

  Future<void> _startCameraStream() async {
    final request = await Permission.camera.request();

    if (request.isGranted) {
      await BodyDetection.enablePoseDetection();
      // print('☠️ enable~startCameraStream');
      await BodyDetection.startCameraStream(
        onFrameAvailable: _handleCameraImage,
        onPoseAvailable: (pose) {
          // print('onposeAvailable');
          _handlePose(pose);
        },
      );
    }

    setState(() {
      _detectedPose = null;
      // print('☠️ log: _detectedPose = null');
    });
  }

  Stream<bool> _startTimerStream() async* {
    while (true) {
      if (isActiveStart) {
        break;
      }
      await Future.delayed(const Duration(
        seconds: 1,
      ));
    }

    await flutterTts.speak('3초뒤 운동을 시작합니다');
    await Future.delayed(const Duration(milliseconds: 3000));
    await flutterTts.speak('3');
    await Future.delayed(const Duration(milliseconds: 1000));
    await flutterTts.speak('2');
    await Future.delayed(const Duration(milliseconds: 1000));
    await flutterTts.speak('1');
    await Future.delayed(const Duration(milliseconds: 1000));
    await flutterTts.speak('시작');
    await Future.delayed(const Duration(milliseconds: 1000));

    int cntTemp = 0;
    bool isFirst = true;
    while (true) {
      if(thisCounter == widget.counter*2){
        break;
      }
      if (cntTemp == 0) {
        cntTemp++;
        if (isFirst) {
          isFirst = false;
          continue;
        }
        yield false;
        await Future.delayed(Duration(milliseconds: breakTimeMillisecond));
      } else if (cntTemp < readyBeepCount + 1) {
        cntTemp++;
        yield false;
        await Future.delayed(Duration(
          milliseconds: readyBeepTermMillisecond,
        ));
      } else {
        cntTemp = 0;
        yield true;
        await Future.delayed(Duration(
          milliseconds: inScoringTimeMillisecond,
        ));
      }
    }

    await Future.delayed(Duration(
      milliseconds: 2000,
    ));
    flutterTts.speak('수고 하셨습니다.');
    _stopCameraStream();
    // Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ResultPage(
              actionname: widget.actionname,
              startTime: startTime,
            )));
  }

  Future<void> _stopCameraStream() async {
    await BodyDetection.stopCameraStream();

    setState(() {
      _cameraImage = null;
      _imageSize = Size.zero;
      // print('☠️ log: _stopCameraStream');
    });
  }

  void _handleCameraImage(ImageResult result) {
    // Ignore callback if navigated out of the page.
    if (!mounted) return;

    // To avoid a memory leak issue.
    // https://github.com/flutter/flutter/issues/60160
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    // print('☠️ log: _handleCameraImage');

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

  void _handlePose(Pose? pose) {
    // Ignore if navigated out of the page.
    if (!mounted) return;
    // print('☠️ log: _handlePose');
    // 여기 pose 좌표 있음
    currentMilliSecondsCompletePose = DateTime.now().millisecondsSinceEpoch;
    if (pose != null) {
      isInCamera = true;
      for (final part in pose.landmarks) {
        if (part.position.x < 0 ||
            part.position.x > _imageSize.width ||
            part.position.y < 0 ||
            part.position.y > _imageSize.height) {
          setState(() {
            isInCamera = false;
            isInCameraCnt = 0;
          });
        }
      }
      if (isInCamera) {
        setState(() {
          isInCamera = true;
          isInCameraCnt += 2;
          if (isInCameraCnt > 99) {
            isActiveStart = true;
          }
        });
      }
    } else {
      setState(() {
        isInCamera = false;
        isInCameraCnt = 0;
      });
    }

    setState(() {
      infTime =
          currentMilliSecondsCompletePose - currentMilliSecondsCompleteImage;
      dectTime = currentMilliSecondsCompletePose - currentMilliSecondsPostTemp;
      currentMilliSecondsPostTemp = currentMilliSecondsCompletePose;
      // print('💡 InfTime: $infTime');
      _detectedPose = pose;
    });
  }

  Widget get _cameraDetectionView => Center(
        child: Stack(
          children: [
            ClipRect(
              child: CustomPaint(
                child: _cameraImage,
                foregroundPainter: !isInFeedbackTime
                    ? PoseMaskPainter(
                        pose: _detectedPose,
                        mask: _maskImage,
                        imageSize: _imageSize,
                      )
                    : widget.actionname == '사이드 크런치'
                        ? StandingSideCrunchPainter(
                            pose: _detectedPose,
                            mask: _maskImage,
                            imageSize: _imageSize,
                          )
                        : BirdDogPainter(
                            pose: _detectedPose,
                            mask: _maskImage,
                            imageSize: _imageSize),
              ),
            ),
            Positioned(
              left: -70,
              top: -70,
              child: Icon(
                Icons.add_outlined,
                size: 150,
                color: isInCamera ? Colors.green : Colors.red,
              ),
            ),
            Positioned(
              right: -70,
              top: -70,
              child: Icon(
                Icons.add_outlined,
                size: 150,
                color: isInCamera ? Colors.green : Colors.red,
              ),
            ),
            Positioned(
              left: -70,
              bottom: -70,
              child: Icon(
                Icons.add_outlined,
                size: 150,
                color: isInCamera ? Colors.green : Colors.red,
              ),
            ),
            Positioned(
              right: -70,
              bottom: -70,
              child: Icon(
                Icons.add_outlined,
                size: 150,
                color: isInCamera ? Colors.green : Colors.red,
              ),
            ),
            !isActiveStart
                ? Positioned.fill(
                    child: Align(
                        alignment: Alignment.center,
                        child: !isInCamera
                            ? Container(
                                decoration: BoxDecoration(
                                    color: Color(0xCCffffff),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 10, 30, 10),
                                  child: Text(
                                    '프레임 안으로\n들어와주세요!',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Color(0xCCffffff),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                height: 80,
                                child: Column(
                                  children: [
                                    Text(
                                      '100% 가 될때까지',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '화면 밖으로 벗어나지 마세요',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '$isInCameraCnt %',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                  )
                : Positioned(child: Text('운동 시작')),
            Positioned(
              right: 20,
              top: 20,
              child: IconButton(
                onPressed: () {
                  _stopCameraStream();
                  // Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResultPage(
                                actionname: widget.actionname,
                                startTime: startTime,
                              )));
                },
                icon: const Icon(
                  Icons.cancel_outlined,
                  size: 40,
                  color: Color(0xDDffffff),
                ),
              ),
            ),
            Positioned(
                left: 20,
                top: 10,
                child: Text(
                  'fps : ${1000 ~/ dectTime}',
                  style: TextStyle(color: Colors.green, fontSize: 20),
                ))
          ],
        ),
      );

  @override
  void dispose() {
    super.dispose();
    _stopCameraStream();
    // print('☠️ log: dispose');
    timerStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _cameraDetectionView,
    );
  }
}
