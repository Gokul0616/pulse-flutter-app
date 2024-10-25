import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isError = false;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isFullScreen = false;
  bool _controlsVisible = true;
  Timer? _controlsTimer;
  bool _isVideoCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
      await _videoPlayerController.initialize();

      _videoPlayerController.addListener(() {
        if (_videoPlayerController.value.position ==
            _videoPlayerController.value.duration) {
          setState(() {
            _isVideoCompleted = true;
            _controlsVisible = true; // Show controls when video is completed
            _controlsTimer?.cancel(); // Prevent the timer from hiding controls
          });
        } else if (_videoPlayerController.value.isPlaying) {
          setState(() {
            _isVideoCompleted = false;
          });
        }
      });

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        autoPlay: true,
        looping: false,
        allowFullScreen: false,
        showControls: false, // We handle controls manually
        autoInitialize: true,
      );

      setState(() {
        _isError = false;
        _startControlsTimer();
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isError = true;
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.removeListener(() {});
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    _controlsTimer?.cancel();
    super.dispose();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      _controlsVisible = true;
    });

    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  void _toggleControls() {
    setState(() {
      _controlsVisible = !_controlsVisible;
    });

    if (_controlsVisible) {
      _startControlsTimer(); // Only start timer when controls are shown
    } else {
      _controlsTimer?.cancel(); // Cancel timer when hiding controls
    }
  }

  void _onTap() {
    _toggleControls(); // Show or hide controls when tapped
  }

  void _doubleTapPlayPause() {
    setState(() {
      if (_isVideoCompleted) {
        _videoPlayerController.seekTo(Duration.zero);
        _videoPlayerController.play();
        _isVideoCompleted = false;
      } else {
        _videoPlayerController.value.isPlaying
            ? _videoPlayerController.pause()
            : _videoPlayerController.play();
      }
    });

    // Restart controls timer only when user interacts
    if (_controlsVisible) {
      _startControlsTimer();
    }
  }

  void _startControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _controlsVisible = false; // Hide controls after 3 seconds
      });
    });
  }

  void test() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return GestureDetector(
              onTap: _onTap,
              onDoubleTap: _doubleTapPlayPause,
              child: Stack(
                children: [
                  if (_isLoading)
                    const Center(
                        child: CircularProgressIndicator(color: Colors.red))
                  else if (_isError)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Error loading video: $_errorMessage',
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  else if (orientation == Orientation.portrait &&
                      _chewieController != null)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      child: Chewie(controller: _chewieController!),
                    )
                  else if (_chewieController != null)
                    Chewie(controller: _chewieController!),
                  if (!_isFullScreen && _controlsVisible)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                        child: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  if (_controlsVisible) _buildControls(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildControls() {
    if (_chewieController == null) return const SizedBox.shrink();

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.black54,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            VideoProgressIndicator(
              _chewieController!.videoPlayerController,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.red,
                bufferedColor: Colors.grey,
                backgroundColor: Colors.transparent,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    _isVideoCompleted
                        ? Icons.replay
                        : (_videoPlayerController.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow),
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_isVideoCompleted) {
                        // Reset video to the start and play
                        _isVideoCompleted = false;
                        _videoPlayerController.seekTo(Duration.zero);
                        _videoPlayerController.play();
                        test();
                      } else {
                        // Toggle play/pause state
                        _videoPlayerController.value.isPlaying
                            ? _videoPlayerController.pause()
                            : _videoPlayerController.play();
                      }
                    });

                    // If controls are visible, restart the timer to hide them after interaction
                    if (_controlsVisible) {
                      _startControlsTimer();
                    } else if (_isVideoCompleted) {
                      // If the video was completed and replayed, restart the timer
                      _startControlsTimer();
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                    color: Colors.white,
                  ),
                  onPressed: _toggleFullScreen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
