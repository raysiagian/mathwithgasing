import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/level_type/material_video.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/unit/unit.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/material_level_screen/widget/button_to_map_video.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/pages/map_unit_level.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({
    Key? key,
    required this.materi,
    required this.unit,
    required this.materialVideo,
  }) : super(key: key);

  final Materi materi;
  final Unit unit;
  final MaterialVideo materialVideo;

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  String _videoUrl = '';

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;

    // Fetch video data from Postman API
    _fetchVideoData();
  }

  Future<void> _fetchVideoData() async {
    final response = await http.get(Uri.parse(baseurl + 'api/getMaterialVideoByUnit?id_unit=${widget.unit.id_unit}'));


    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final videoData = jsonData['data'][0];

      setState(() {
        _videoUrl = videoData['video_Url'];
      });

      // Initialize the YoutubePlayerController with fetched video URL
      _initializeYoutubePlayer(_videoUrl);
    } else {
      throw Exception('Failed to load video data');
    }
  }

  void _initializeYoutubePlayer(String videoUrl) {
    String videoId = YoutubePlayer.convertUrlToId(videoUrl)!;
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: true,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
        hideThumbnail: true,
        hideControls: true,
        controlsVisibleAtStart: false,
        showLiveFullscreenButton: false,
      ),
    )..addListener(listener);
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

 @override
  Widget build(BuildContext context) {
    if (_videoUrl.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.blueAccent,
          topActions: <Widget>[
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                _controller.metadata.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 25.0,
              ),
              onPressed: () {
                debugPrint('Settings Tapped!');
              },
            ),
          ],
          onReady: () {
            _isPlayerReady = true;
          },
          onEnded: (data) {
            _showButton('Kembali Ke Map');
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             ElevatedButton(
          onPressed: () {
            if (_isPlayerReady) {
              _controller.pause();
            }
          },
          child: const Text("Pause"),
        ),
        SizedBox(width: 50,),
        ElevatedButton(
          onPressed: () {
            if (_isPlayerReady) {
              _controller.play();
            }
          },
          child: const Text("Play"),
        ),
          ],
        )
      ],
    );
  }


  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700]!;
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900]!;
      default:
        return Colors.blue;
    }
  }

  Widget get _space => const SizedBox(height: 10);

void _showButton(String message) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BackToMapVideo(
                materi: widget.materi,
                unit: widget.unit,
                materialVideo: widget.materialVideo,
              ),
            ],
          ),
        );
      },
    );
  }
}
