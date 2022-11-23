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
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
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

  void _handlePose(Pose? pose) {
    // Ignore if navigated out of the page.
    if (!mounted) return;
    print('☠️ log: _handlePose');
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
          });
        }
      }
      if (isInCamera) {
        setState(() {
          isInCamera = true;
        });
      }
    } else {
      setState(() {
        isInCamera = false;
      });
    }

    setState(() {
      infTime =
          currentMilliSecondsCompletePose - currentMilliSecondsCompleteImage;
      dectTime = currentMilliSecondsCompletePose - currentMilliSecondsPostTemp;
      currentMilliSecondsPostTemp = currentMilliSecondsCompletePose;
      print('💡 InfTime: $infTime');
      _detectedPose = pose;
    });
  }

  Widget get _cameraDetectionView => Center(
        child: Stack(
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
            Positioned.fill(
              child: Align(
                  alignment: Alignment.center,
                  child: !isInCamera
                      ? Container(
                          decoration: BoxDecoration(
                              color: Color(0xCCffffff),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                            child: Text(
                              '프레임 안으로\n들어와주세요!',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                        )
                      : null),
            ),
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
              style: TextStyle(color: Colors.green,fontSize: 20),
            ))
          ],
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
