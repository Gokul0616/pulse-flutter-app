import 'package:Pulse/screens/widgets/component/VideoListScreen_widget.dart';
import 'package:Pulse/screens/widgets/component/post_widget.dart';
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
  bool isLiked = false; // Track if the post is liked
  bool _isVideoCompleted = false;
  bool _showSeekBackwardIndicator = false;
  bool _showSeekForwardIndicator = false;
  Timer? _seekIndicatorTimer;
  bool _isLocked = false;
  bool _isBuffering = false;
  // final PageController _pageController = PageController();
  // int _currentPageIndex = 0; // Track the current page index
  bool isPlaybackPage = false;

  // Playback speed options
  final List<double> _playbackSpeeds = [
    0.25,
    0.5,
    0.75,
    1.0,
    1.25,
    1.5,
    1.75,
    2.0
  ];
  double _currentPlaybackSpeed = 1.0;

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
        // Check if the video has completed
        if (_videoPlayerController.value.position ==
            _videoPlayerController.value.duration) {
          setState(() {
            _isVideoCompleted = true;
            _isBuffering = false;

            // Check if controls are locked
            if (!_isLocked) {
              _controlsVisible = true; // Show controls if not locked
            } else {
              _controlsVisible = false; // Hide controls if locked
            }

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

  void _showPlaybackSpeedOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Playback Speed"),
          content: SingleChildScrollView(
            child: ListBody(
              children: _playbackSpeeds.map((speed) {
                return ListTile(
                  title: Text(speed.toString()),
                  onTap: () {
                    setState(() {
                      _currentPlaybackSpeed = speed;
                      _videoPlayerController.setPlaybackSpeed(speed);
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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

  void _toggleLock() {
    setState(() {
      _isLocked = !_isLocked;
      _controlsVisible = !_isLocked; // Hide controls if locked
    });
  }

// Show lock icon when tapping on the video while controls are locked
  void _showLockIcon() {
    setState(() {
      _controlsVisible = false;
      // You could set a timer to auto-hide the lock icon if desired
    });
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

//   void _doubleTap(TapDownDetails details) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight =  MediaQuery.of(context).size.height * 0.25;
//     final tapPosition = details.localPosition.dx;
// if()
//     if (tapPosition < screenWidth / 2) {
//       _seekBackward();
//     } else {
//       _seekForward();
//     }
//   }
  void _doubleTap(TapDownDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height *
        0.25; // Only use the top 25% of the screen
    final tapPosition = details.localPosition; // Get both x and y positions

    // Check if the tap is within the top 25% of the screen and left or right half
    if (_isFullScreen) {
      if (tapPosition.dx < screenWidth / 2) {
        _seekBackward();
      } else {
        _seekForward();
      }
    } else {
      if (tapPosition.dy < screenHeight) {
        if (tapPosition.dx < screenWidth / 2) {
          _seekBackward(); // Seek backward if tap is on the left half
        } else {
          _seekForward(); // Seek forward if tap is on the right half
        }
      }
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

  void _openSettingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
              ),
              width: _isFullScreen
                  ? MediaQuery.of(context).size.width * 0.6
                  : MediaQuery.of(context).size.width * 0.95,
              height: _isFullScreen
                  ? MediaQuery.of(context).size.height * 0.7
                  : MediaQuery.of(context).size.height * 0.3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(color: Colors.grey),
                  ListTile(
                    leading: const Icon(Icons.video_settings),
                    title: const Text("Video Quality"),
                    onTap: () {
                      // Handle video quality change
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text("Lock Screen"),
                    onTap: () {
                      Navigator.of(context)
                          .pop(); // Close the current bottom sheet
                      _toggleLock();
                      // Handle lock screen
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.play_circle_outline),
                    title: const Text("Playback Speed"),
                    onTap: () {
                      Navigator.of(context)
                          .pop(); // Close the current bottom sheet
                      _openPlaybackSpeedBottomSheet(); // Open new bottom sheet
                    },
                  ),
                  // ListTile(
                  //   leading: Icon(Icons.subtitles),
                  //   title: Text("Subtitles"),
                  //   onTap: () {
                  //     // Handle subtitles toggle
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openPlaybackSpeedBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
              ),
              width: _isFullScreen
                  ? MediaQuery.of(context).size.width * 0.6
                  : MediaQuery.of(context).size.width * 0.95,
              height: _isFullScreen
                  ? MediaQuery.of(context).size.height * 0.85
                  : MediaQuery.of(context).size.height * 0.5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Playback Speed",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(color: Colors.grey),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _playbackSpeeds.length,
                      itemBuilder: (context, index) {
                        bool isCurrentSpeed =
                            _playbackSpeeds[index] == _currentPlaybackSpeed;

                        return ListTile(
                          leading: isCurrentSpeed
                              ? const Icon(Icons.circle,
                                  size: 10, color: Colors.black)
                              : null,
                          title: Text(_playbackSpeeds[index].toString()),
                          onTap: () {
                            setState(() {
                              _currentPlaybackSpeed = _playbackSpeeds[index];
                              _videoPlayerController
                                  .setPlaybackSpeed(_currentPlaybackSpeed);
                            });
                            Navigator.of(context)
                                .pop(); // Close playback speed sheet
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
          child: Stack(
            children: [
              OrientationBuilder(
                builder: (context, orientation) {
                  return SizedBox(
                    child: Column(
                      children: [
                        // Video Player
                        SizedBox(
                          height: orientation == Orientation.portrait
                              ? MediaQuery.of(context).size.height * 0.25
                              : MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: GestureDetector(
                            onTap: _isLocked
                                ? _showLockIcon
                                : _onTap, // Show lock icon if locked
                            onDoubleTapDown: _isLocked ? null : _doubleTap,
                            child: Stack(
                              children: [
                                if (_isLoading)
                                  const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.red),
                                        
                                  )
                                else if (_isError)
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      'Error loading video: $_errorMessage',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  )
                                else if (_chewieController != null)
                                  Chewie(controller: _chewieController!),

                                // Seek indicators for double-tap
                                if ((_showSeekBackwardIndicator ||
                                        _showSeekForwardIndicator) &&
                                    !_isFullScreen)
                                  Positioned(
                                    top: MediaQuery.of(context).size.height /
                                        8.5,
                                    left:
                                        _showSeekBackwardIndicator ? 50 : null,
                                    right:
                                        _showSeekForwardIndicator ? 50 : null,
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
                                    top:
                                        MediaQuery.of(context).size.height / 2 -
                                            40,
                                    left:
                                        _showSeekBackwardIndicator ? 50 : null,
                                    right:
                                        _showSeekForwardIndicator ? 50 : null,
                                    child: Icon(
                                      _showSeekBackwardIndicator
                                          ? Icons.fast_rewind
                                          : Icons.fast_forward,
                                      size: 80,
                                      color: Colors.white,
                                    ),
                                  ),
                                // Lock Icon displayed at top right if video controls are locked
                                if (_isLocked)
                                  Positioned(
                                    top: MediaQuery.of(context).size.height *
                                        0.01,
                                    right: 16,
                                    child: IconButton(
                                      icon: const Icon(Icons.lock,
                                          color: Colors.white),
                                      onPressed: _toggleLock,
                                    ),
                                  ),

                                // Loading indicator for buffering - adjusted position
                                if (_isBuffering && !_isFullScreen)
                                  Positioned(
                                    top: MediaQuery.of(context).size.height /
                                        8.5, // Center vertically
                                    left:
                                        MediaQuery.of(context).size.width / 2 -
                                            20, // Center horizontally
                                    child: Container(
                                      color: Colors
                                          .transparent, // Make the background transparent
                                      child: const CircularProgressIndicator(
                                          color: Colors.red),
                                    ),
                                  ),
                                if (_isBuffering && _isFullScreen)
                                  Positioned(
                                    top:
                                        MediaQuery.of(context).size.height / 2 -
                                            20, // Center vertically
                                    left:
                                        MediaQuery.of(context).size.width / 2 -
                                            20, // Center horizontally
                                    child: Container(
                                      color: Colors
                                          .transparent, // Make the background transparent
                                      child: const CircularProgressIndicator(
                                          color: Colors.red),
                                    ),
                                  ),

                                if (!_isFullScreen && _controlsVisible)
                                  Positioned(
                                    top: MediaQuery.of(context).size.height *
                                        0.01,
                                    left: 16,
                                    child: Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(50),
                                      child: IconButton(
                                        icon: const Icon(Icons.arrow_back,
                                            color: Colors.white),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ),
                                if (_isFullScreen && _controlsVisible)
                                  Positioned(
                                    top: MediaQuery.of(context).size.height *
                                        0.01,
                                    left: 16,
                                    child: Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(50),
                                      child: IconButton(
                                        icon: const Icon(Icons.arrow_back,
                                            color: Colors.white),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _toggleFullScreen();
                                        },
                                      ),
                                    ),
                                  ),
                                if (_controlsVisible && !_isLoading)
                                  Positioned(
                                    top: MediaQuery.of(context).size.height *
                                        0.01,
                                    right: 16,
                                    child: Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(50),
                                      child: IconButton(
                                        icon: const Icon(Icons.settings,
                                            color: Colors.white),
                                        onPressed: () {
                                          _openSettingsBottomSheet();
                                        },
                                      ),
                                    ),
                                  ),
                                if (_controlsVisible) _buildControls(),
                              ],
                            ),
                          ),
                        ),
                        // Video List (Only visible in portrait mode)
                        if (orientation == Orientation.portrait)
                          Expanded(
                              child: Container(
                            color: Colors.white,
                            child: ListView(
                              children: [
                                VideoListScreen(
                                  videoItems: [
                                    VideoItem(
                                      url:
                                          'https://onlinetestcase.com/wp-content/uploads/2023/06/15MB.mp4',
                                      thumbnailUrl:
                                          'https://images.ctfassets.net/hrltx12pl8hq/28ECAQiPJZ78hxatLTa7Ts/2f695d869736ae3b0de3e56ceaca3958/free-nature-images.jpg?fit=fill&w=1200&h=630',
                                      title: 'Sample Video 2',
                                      userProfileUrl:
                                          'https://randomuser.me/api/portraits/men/32.jpg',
                                      userName: 'John Doe',
                                      userHandle: 'johndoe',
                                      uploadTime: '2 hours ago',
                                      viewCount: '1.2K',
                                      duration: '3:45',
                                    ),
                                    // Add more VideoItem objects as needed
                                  ],
                                  onVideoClicked: (VideoItem) {
                                    Navigator.pop(context);
                                  },
                                ),
                                // Add more VideoItem objects as needed
                                PostWidget(
                                  userName: "Username",
                                  postTime: "10 minutes ago",
                                  userProfileUrl:
                                      "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
                                  postUrl:
                                      "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
                                  isLiked: isLiked,
                                  onLikeToggle: () {
                                    setState(() {
                                      isLiked = !isLiked; // Toggle like state
                                    });
                                  },
                                  onCommentPressed: () {
                                    // Handle comment press logic
                                  },
                                ),
                                VideoListScreen(
                                  videoItems: [
                                    VideoItem(
                                      url:
                                          'https://onlinetestcase.com/wp-content/uploads/2023/06/15MB.mp4',
                                      thumbnailUrl:
                                          'https://images.ctfassets.net/hrltx12pl8hq/28ECAQiPJZ78hxatLTa7Ts/2f695d869736ae3b0de3e56ceaca3958/free-nature-images.jpg?fit=fill&w=1200&h=630',
                                      title: 'Sample Video 2',
                                      userProfileUrl:
                                          'https://randomuser.me/api/portraits/men/32.jpg',
                                      userName: 'John Doe',
                                      userHandle: 'johndoe',
                                      uploadTime: '2 hours ago',
                                      viewCount: '1.2K',
                                      duration: '3:45',
                                    ),
                                    // Add more VideoItem objects as needed
                                  ],
                                  onVideoClicked: (VideoItem) {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          )),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

// Function to handle video tap

  Widget _buildControls() {
    if (_chewieController == null) return const SizedBox.shrink();
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: _controlsVisible ? 1.0 : 0.0, // Controls visibility
        duration: const Duration(
            milliseconds: 1500), // Fade duration set to 1.5 seconds
        curve: Curves.easeInOut, // Smooth easing curve
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
