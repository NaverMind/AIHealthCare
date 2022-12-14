import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/material.dart';

class Player extends StatefulWidget {
  final String _videoID;
  final String _videoTitle;

  Player(this._videoID, this._videoTitle);

  @override
  PlayerState createState() => PlayerState(_videoID, _videoTitle);
}

class PlayerState extends State<Player> {
  final String _videoID;
  final String _videoTitle;

  PlayerState(this._videoID, this._videoTitle);

  late YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: _videoID,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
    _videoID == 'uBZl8x_Vclc' ?
    setHori() : null;
  }

  void setVer() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  void setHori() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void setRotateAvai() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([]);
  }

  @override
  void dispose() {
    super.dispose();
    setRotateAvai();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: YoutubePlayer(
          key: ObjectKey(_controller),
          controller: _controller,
          actionsPadding: const EdgeInsets.only(left: 16.0),
          aspectRatio: 9/16,
          bottomActions: [
            const SizedBox(width: 10.0),
            CurrentPosition(),
            const SizedBox(width: 10.0),
            ProgressBar(isExpanded: true),
            const SizedBox(width: 10.0),
            RemainingDuration(),
            // FullScreenButton(),
          ],
          topActions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.cancel_outlined,
                size: 40,
                color: Colors.red,
              ),
            ),
          ],
          onEnded: (_) {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
