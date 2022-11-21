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
