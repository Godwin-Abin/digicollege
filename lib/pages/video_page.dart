import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart' as media_kit;
import 'package:media_kit_video/media_kit_video.dart';

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
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  Duration? _totalDuration;
  bool _popupShown = false;
  
  // Attendance tracking variables
  int _attendedCount = 0;
  int _popupShownCount = 0;
  List<int> _popupTimes = [];
  int _nextPopupIndex = 0;
  bool _resultSent = false;

  @override
  void initState() {
    super.initState();
    media_kit.MediaKit.ensureInitialized();
    _player = media_kit.Player();
    _videoController = VideoController(_player);

    // Listen for video completion to pop the page.
    _completedSubscription = _player.streams.completed.listen((completed) {
      if (completed && mounted && !_resultSent) {
        _resultSent = true;
        Navigator.pop(context, _attendedCount >= 3 ? 1 : 0);
      }
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

    // Subscribe to duration stream to get total video duration.
    _durationSubscription = _player.streams.duration.listen((duration) {
      if (duration.inSeconds >= 300) {
        _schedulePopups(duration);
      }
      setState(() {
        _totalDuration = duration;
      });
    });

    // Subscribe to position stream to trigger popups at scheduled times
    _positionSubscription = _player.streams.position.listen((position) {
      if (_totalDuration == null || _popupTimes.isEmpty) return;
      if (_nextPopupIndex < _popupTimes.length &&
          position.inSeconds >= _popupTimes[_nextPopupIndex]) {
        _showPopup();
        _nextPopupIndex++;
        _popupShownCount++;
      }
    });

    _player.open(media_kit.Media(widget.videoUrl));
  }

  void _schedulePopups(Duration duration) {
    final random = Random();
    // First popup between 30-75 seconds
    _popupTimes.add(30 + random.nextInt(45)); // 30 + random(0-44) = 30-74 seconds

    // Generate four random times between 300 and total duration
    for (int i = 0; i < 4; i++) {
      int max = duration.inSeconds - 300;
      if (max <= 0) break;
      _popupTimes.add(300 + random.nextInt(max));
    }
    _popupTimes.sort();
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

  // Display the popup and pause the video.
  Future<void> _showPopup() async {
    // Pause the video.
    _player.pause();

    bool userContinued = false;
    Timer? popupTimer;

    // Show the dialog. The dialog is not dismissible by tapping outside.
    userContinued = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        // Start a timer that auto-closes the dialog after 30 seconds.
        popupTimer = Timer(const Duration(seconds: 30), () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context, false);
          }
        });
        return AlertDialog(
          title: const Text("Continue Watching?"),
          content: const Text("Do you want to continue watching the video?"),
          actions: [
            TextButton(
              onPressed: () {
                popupTimer?.cancel();
                Navigator.pop(context, true);
              },
              child: const Text("Continue"),
            ),
          ],
        );
      },
    ) ?? false;

    // Cancel the timer if it's still active.
    if (popupTimer != null && popupTimer!.isActive) {
      popupTimer!.cancel();
    }

    if (userContinued) {
      _attendedCount++;
      _player.play();
    } else {
      if (!_resultSent) {
        _resultSent = true;
        Navigator.pop(context, _attendedCount >= 3 ? 1 : 0);
      }
    }

    // Check if all popups are shown and send result
    if (_popupShownCount >= 5 && !_resultSent) {
      _resultSent = true;
      Navigator.pop(context, _attendedCount >= 3 ? 1 : 0);
    }
  }

  @override
  void dispose() {
    if (!_resultSent) {
      _resultSent = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pop(_attendedCount >= 3 ? 1 : 0);
        }
      });
    }
    _completedSubscription?.cancel();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _player.dispose();
    // Restore system UI and portrait orientation.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
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

    return WillPopScope(
      onWillPop: () async {
        if (!_resultSent) {
          _resultSent = true;
          Navigator.pop(context, _attendedCount >= 3 ? 1 : 0);
        }
        return false;
      },
      child: Scaffold(
        appBar: _isFullScreen ? null : AppBar(title: const Text("Video Player")),
        body: SafeArea(child: videoContent),
      ),
    );
  }
}
