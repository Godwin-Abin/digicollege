import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart' as media_kit;
import 'package:media_kit_video/media_kit_video.dart';
import 'dart:async';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as youtube;

class VideoPage extends StatefulWidget {
  final String videoUrl;

  const VideoPage({super.key, required this.videoUrl});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late final media_kit.Player _player;
  late final VideoController _videoController;
  bool _isLoading = true;
  bool _showPlayButton = true;
  double _volume = 100;
  StreamSubscription<bool>? _completedSubscription;
  youtube.YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    media_kit.MediaKit.ensureInitialized();
    _player = media_kit.Player();
    _videoController = VideoController(_player);

    final videoId = youtube.YoutubePlayer.convertUrlToId(widget.videoUrl);
    if (videoId != null) {
      // Initialize YouTube player
      _youtubeController = youtube.YoutubePlayerController(
        initialVideoId: videoId,
        flags: const youtube.YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: true,
        ),
      )..addListener(() {
        if (_youtubeController!.value.playerState ==
            youtube.PlayerState.ended) {
          Navigator.pop(context);
        }
      });
    } else {
      // Initialize media_kit player
      _completedSubscription = _player.streams.completed.listen((completed) {
        if (completed && mounted) Navigator.pop(context);
      });

      _player.streams.playing.listen((isPlaying) {
        if (mounted) {
          setState(() {
            _isLoading = !isPlaying;
            _showPlayButton = !isPlaying;
          });
        }
      });

      _player.streams.buffering.listen((isBuffering) {
        if (mounted) setState(() => _isLoading = isBuffering);
      });

      _player.open(media_kit.Media(widget.videoUrl));
    }
  }

  @override
  void dispose() {
    _completedSubscription?.cancel();
    _player.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Player")),
      body:
          _youtubeController != null
              ? youtube.YoutubePlayer(
                controller: _youtubeController!,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blueAccent,
                onEnded: (metaData) => Navigator.pop(context),
              )
              : Stack(
                children: [
                  Video(controller: _videoController, controls: null),
                  if (_showPlayButton && _isLoading)
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _player.play();
                          setState(() => _showPlayButton = false);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  if (_isLoading && !_showPlayButton)
                    const Center(child: CircularProgressIndicator()),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.volume_up, color: Colors.white),
                          SizedBox(
                            width: 150,
                            child: Slider(
                              value: _volume,
                              min: 0,
                              max: 100,
                              divisions: 10,
                              onChanged: (value) {
                                setState(() => _volume = value);
                                _player.setVolume(value);
                              },
                              activeColor: Colors.white,
                              inactiveColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
