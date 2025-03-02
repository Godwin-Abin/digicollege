import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart' as media_kit;
import 'package:media_kit_video/media_kit_video.dart';
import 'dart:async';

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
  bool _isFullScreen = false;
  StreamSubscription<bool>? _completedSubscription;

  @override
  void initState() {
    super.initState();
    media_kit.MediaKit.ensureInitialized();
    _player = media_kit.Player();
    _videoController = VideoController(_player);

    // Listen for video completion to pop the page.
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

  @override
  void dispose() {
    _completedSubscription?.cancel();
    _player.dispose();
    // Restore system UI and portrait orientation.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  // Toggle full screen mode.
  void _toggleFullScreen() {
    if (!_isFullScreen) {
      // Enter full screen: hide overlays and force landscape.
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      // Exit full screen: restore overlays and portrait orientation.
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoContent = Stack(
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
        // Full screen toggle button overlay.
        Positioned(
          top: 20,
          right: 20,
          child: IconButton(
            icon: Icon(
              _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Colors.white,
              size: 30,
            ),
            onPressed: _toggleFullScreen,
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: _isFullScreen ? null : AppBar(title: const Text("Video Player")),
      body: SafeArea(child: videoContent),
    );
  }
}
