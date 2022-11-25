import 'package:body_detection/models/pose.dart';
import 'package:body_detection/body_detection.dart';

class Exercise {
  Map<double, String> scores = {0:'0'};

  Exercise();

  void SSCScore(Pose detectedPose) {
    double score = 0;
    String feedback;
    for (final part in detectedPose.landmarks) {
      score += part.position.x;
    }
    feedback = '$score 입니다';
    scores[score] = feedback;
  }

  void BDScore(Pose detectedPose) {
    double score = 0;
    String feedback;
    for (final part in detectedPose.landmarks) {
      score += part.position.x;
    }
    feedback = '$score 입니다';
    scores[score] = feedback;
  }

  String? chooseOne(){
    double max = 0;
    for (final one in scores.keys){
      if(one > max) {
        max = one;
      }
    }
    return scores[max];
  }

  void del(){
    scores.clear();
    scores[0] = "0";
  }
}
