import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late final Player _player;
  late final VideoController _videoController;
  bool _isLoading = true;
  bool _showPlayButton = true;
  double _volume = 100;

  @override
  void initState() {
    super.initState();
    MediaKit.ensureInitialized();
    _player = Player();
    _videoController = VideoController(_player);

    // Listen to the playing stream.
    _player.streams.playing.listen((isPlaying) {
      if (isPlaying) {
        setState(() {
          _isLoading = false;
          _showPlayButton = false;
        });
      } else {
        // Optionally update UI when playback stops.
        setState(() => _showPlayButton = true);
      }
    });

    // Listen to the buffering stream.
    _player.streams.buffering.listen((isBuffering) {
      setState(() => _isLoading = isBuffering);
    });

    _player.open(
      Media(
        'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Player")),
      body: Stack(
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
