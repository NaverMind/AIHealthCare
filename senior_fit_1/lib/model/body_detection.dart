import 'dart:async';

import 'package:body_detection/models/image_result.dart';
import 'package:body_detection/models/pose.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:body_detection/body_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:senior_fit_1/model/standing_side_crunch.dart';
import 'pose_mask_painter.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:senior_fit_1/model/bird_dog.dart';

class DetectPage extends StatefulWidget {
  final String actionname;

  DetectPage({
    Key? key,
    required this.actionname,
  }) : super(key: key);

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
  int infTime = DateTime.now().millisecondsSinceEpoch;
  int dectTime = DateTime.now().millisecondsSinceEpoch;
  bool isInCamera = false;
  int isInCameraCnt = 0;
  final FlutterTts flutterTts = FlutterTts();
  late Stream<bool> timerStream;
  late StreamSubscription timerStreamSubscription;
  bool isActiveStart = false;
  bool isInFeedbackTime = false;

  @override
  void initState() {
    super.initState();
    _startCameraStream();
    // print('☠️ log: initState');
    flutterTts.setLanguage('ko');
    flutterTts.setSpeechRate(0.4);
    timerStream = _startTimerStream();
    timerStreamSubscription = timerStream.listen((event) {
      if (event) {
        FlutterBeep.beep(true);
        setState(() {
          isInFeedbackTime = true;
        });
      } else {
        FlutterBeep.beep(false);
        setState(() {
          isInFeedbackTime = false;
        });
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
    await Future.delayed(const Duration(seconds: 3));
    await flutterTts.speak('3');
    await Future.delayed(const Duration(milliseconds: 1000));
    await flutterTts.speak('2');
    await Future.delayed(const Duration(milliseconds: 1000));
    await flutterTts.speak('1');
    await Future.delayed(const Duration(milliseconds: 1000));
    await flutterTts.speak('시작');
    await Future.delayed(const Duration(milliseconds: 1000));

    int cntTemp = 0;
    while (true) {
      if (cntTemp < 3) {
        cntTemp++;
        yield false;
      } else {
        cntTemp = 0;
        yield true;
        // if (_detectedPose != null) {
        //   if (widget.actionname == 'standing side crunch') {
        //     exercisee.SSCScore(_detectedPose!);
        //     await flutterTts.speak(exercisee.chooseOne()!);
        //   } else if (widget.actionname == 'bird dog') {
        //     exercisee.BDScore(_detectedPose!);
        //     await flutterTts.speak(exercisee.chooseOne()!);
        //   }
        //   exercisee.del();
        // }
      }
      await Future.delayed(const Duration(
        seconds: 1,
      ));
    }
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
      for (final part in pose!.landmarks) {
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
                  Navigator.pop(context);
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
//
// OutlinedButton(
// onPressed: () {},
// child: Text(
// 'InfTime: $infTime',
// style: TextStyle(color: Colors.deepPurple, fontSize: 25),
// ),
// ),
// OutlinedButton(
// onPressed: () {},
// child: Text(
// 'DectTime: $dectTime',
// style: TextStyle(color: Colors.deepPurple, fontSize: 25),
// ),
// ),
// OutlinedButton(
// onPressed: () {},
// child: Text(
// 'IO Time: ${dectTime - infTime}',
// style: TextStyle(color: Colors.deepPurple, fontSize: 25),
// ),
// ),
// OutlinedButton(
// onPressed: () {},
// child: Text(
// 'Img size: ${_imageSize.height} / ${_imageSize.width}',
// style: TextStyle(color: Colors.deepPurple, fontSize: 25),
// ),
// ),
// OutlinedButton(
// onPressed: () {},
// child: Text(
// 'Img size: $isInCamera',
// style: TextStyle(color: Colors.deepPurple, fontSize: 25),
// ),
// ),
