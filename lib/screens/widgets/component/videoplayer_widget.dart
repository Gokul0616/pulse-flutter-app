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
  bool _showSeekBackwardIndicator = false;
  bool _showSeekForwardIndicator = false;
  Timer? _seekIndicatorTimer;
  bool _isBuffering = false;
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
            _controlsVisible = true;
            _isBuffering = false;

            _controlsTimer?.cancel();
          });
        } else if (_videoPlayerController.value.isPlaying) {
          setState(() {
            _isVideoCompleted = false;
            _isBuffering = false;
          });
        } else if (_videoPlayerController.value.isBuffering &&
            !_isVideoCompleted) {
          setState(() {
            _isBuffering = true;
          });
        } else if (_videoPlayerController.value.isPlaying &&
            !_isVideoCompleted) {
          setState(() {
            _startControlsTimer();
          });
        } else {
          setState(() {
            _isBuffering = false;
          });
        }
      });

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        autoPlay: true,
        looping: false,
        allowFullScreen: false,
        showControls: false,
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
    _seekIndicatorTimer?.cancel();
    super.dispose();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      _controlsVisible = true;
    });

    if (_isFullScreen) {
      // Hide status and navigation bars in immersive mode
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    } else {
      // Restore status and navigation bars
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  void _toggleControls() {
    setState(() {
      _controlsVisible = !_controlsVisible;
    });

    if (_controlsVisible) {
      _startControlsTimer();
    } else {
      _controlsTimer?.cancel();
    }
  }

  void _onTap() {
    _toggleControls();
  }

  void _doubleTap(TapDownDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tapPosition = details.localPosition.dx;

    if (tapPosition < screenWidth / 2) {
      _seekBackward();
    } else {
      _seekForward();
    }
  }

  void _seekBackward() {
    final currentPosition = _videoPlayerController.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);

    _videoPlayerController
        .seekTo(newPosition > Duration.zero ? newPosition : Duration.zero);

    // Show the backward indicator
    setState(() {
      _showSeekBackwardIndicator = true;
    });

    _hideSeekIndicator();
  }

  void _seekForward() {
    final currentPosition = _videoPlayerController.value.position;
    final duration = _videoPlayerController.value.duration;
    final newPosition = currentPosition + const Duration(seconds: 10);

    if (newPosition < duration) {
      _videoPlayerController.seekTo(newPosition);
    } else {
      _videoPlayerController.seekTo(duration);
    }

    // Show the forward indicator
    setState(() {
      _showSeekForwardIndicator = true;
    });

    _hideSeekIndicator();
  }


  void _hideSeekIndicator() {
    _seekIndicatorTimer?.cancel();
    _seekIndicatorTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _showSeekBackwardIndicator = false;
        _showSeekForwardIndicator = false;
      });
    });
  }

  void _startControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _controlsVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_isFullScreen) {
            _toggleFullScreen(); // Exit full screen, stay in landscape
            return false; // Prevent exiting the page
          }
          return true; // Allow exiting the page
        },
        child: Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return GestureDetector(
              onTap: _onTap,
              onDoubleTapDown: _doubleTap,
              child: Stack(
                children: [
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    )
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
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width,
                      child: Chewie(controller: _chewieController!),
                    )
                  else if (_chewieController != null)
                    Chewie(controller: _chewieController!),

                  // Seek indicators for double-tap
                  if ((_showSeekBackwardIndicator ||
                          _showSeekForwardIndicator) &&
                      !_isFullScreen)
                    Positioned(
                      top: MediaQuery.of(context).size.height / 8.5,
                      left: _showSeekBackwardIndicator ? 50 : null,
                      right: _showSeekForwardIndicator ? 50 : null,
                      child: Icon(
                        _showSeekBackwardIndicator
                            ? Icons.fast_rewind
                            : Icons.fast_forward,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  if ((_showSeekBackwardIndicator ||
                          _showSeekForwardIndicator) &&
                      _isFullScreen)
                    Positioned(
                      top: MediaQuery.of(context).size.height / 2 - 40,
                      left: _showSeekBackwardIndicator ? 50 : null,
                      right: _showSeekForwardIndicator ? 50 : null,
                      child: Icon(
                        _showSeekBackwardIndicator
                            ? Icons.fast_rewind
                            : Icons.fast_forward,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),

                  // Loading indicator for buffering - adjusted position
                  if (_isBuffering && !_isFullScreen)
                    Positioned(
                      top: MediaQuery.of(context).size.height /
                          8.5, // Center vertically
                      left: MediaQuery.of(context).size.width / 2 -
                          20, // Center horizontally
                      child: Container(
                        color: Colors
                            .transparent, // Make the background transparent
                        child:
                            const CircularProgressIndicator(color: Colors.red),
                      ),
                    ),
                  if (_isBuffering && _isFullScreen)
                    Positioned(
                      top: MediaQuery.of(context).size.height / 2 -
                          20, // Center vertically
                      left: MediaQuery.of(context).size.width / 2 -
                          20, // Center horizontally
                      child: Container(
                        color: Colors
                            .transparent, // Make the background transparent
                        child:
                            const CircularProgressIndicator(color: Colors.red),
                      ),
                    ),

                  if (!_isFullScreen && _controlsVisible)
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.01,
                      left: 16,
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                        child: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  if (_isFullScreen && _controlsVisible)
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.01,
                      left: 16,
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                        child: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                            _toggleFullScreen();
                          },
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
        )
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
            // Row to show the current position and duration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Current playback time
                Text(
                  _formatDuration(_videoPlayerController.value.position),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                // Total video duration
                Text(
                  _formatDuration(_videoPlayerController.value.duration),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            // Seek bar
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: VideoProgressIndicator(
              _chewieController!.videoPlayerController,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.red,
                bufferedColor: Colors.grey,
                  backgroundColor: Colors.blueGrey,
              ),
              ),
            ),
            // Control buttons (play/pause, full-screen toggle)
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
                        _isVideoCompleted = false;
                        _videoPlayerController.seekTo(Duration.zero);
                        _videoPlayerController.play();
                      } else {
                        _videoPlayerController.value.isPlaying
                            ? _videoPlayerController.pause()
                            : _videoPlayerController.play();
                      }
                    });

                    if (_controlsVisible) {
                      _startControlsTimer();
                    } else if (_isVideoCompleted) {
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

// Helper function to format duration into mm:ss
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
