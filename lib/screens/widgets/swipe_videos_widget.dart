import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelPlayerWidget extends StatefulWidget {
  final List<String> videoUrls; // List of video URLs to play

  const ReelPlayerWidget({super.key, required this.videoUrls});

  @override
  _ReelPlayerWidgetState createState() => _ReelPlayerWidgetState();
}

class _ReelPlayerWidgetState extends State<ReelPlayerWidget> {
  late PageController _pageController;
  final List<VideoPlayerController?> _videoControllers = [];
  int _currentPage = 0;
  final int _videosToLoadInitially = 3;

  // List to hold like counts for each video
  List<int> _likeCounts = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _likeCounts =
        List.filled(widget.videoUrls.length, 0); // Initialize like counts to 0
    _initializeInitialVideos();
  }

  // Initialize the first 3 video controllers
  Future<void> _initializeInitialVideos() async {
    for (int i = 0; i < _videosToLoadInitially; i++) {
      _initializeVideoController(i);
    }
  }

  // Initialize video controller for a given index
  Future<void> _initializeVideoController(int index) async {
    if (index < widget.videoUrls.length) {
      VideoPlayerController controller =
          VideoPlayerController.network(widget.videoUrls[index]);
      await controller.initialize();
      controller.setLooping(true);
      controller.setVolume(1.0);
      setState(() {
        if (_videoControllers.length <= index) {
          _videoControllers.add(controller);
        } else {
          _videoControllers[index] = controller;
        }
      });

      // Play the first video when it initializes
      if (index == _currentPage) {
        controller.play();
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _videoControllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  // On page change, manage which videos are played/paused and load the next videos
  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });

    // Pause all videos except the current one
    for (int i = 0; i < _videoControllers.length; i++) {
      if (_videoControllers[i] != null && i != _currentPage) {
        _videoControllers[i]!.pause();
      }
    }

    // Play the current video if initialized
    if (_videoControllers[_currentPage] != null) {
      _videoControllers[_currentPage]!.play();
    }
    
    // Load the next video if not already loaded
    if (_currentPage + 1 < widget.videoUrls.length &&
        (_currentPage + 1 >= _videoControllers.length ||
            _videoControllers[_currentPage + 1] == null)) {
      _initializeVideoController(_currentPage + 1);
    }

    // Optionally load two more videos to preload
    // if (_currentPage + 2 < widget.videoUrls.length &&
    //     (_currentPage + 2 >= _videoControllers.length ||
    //         _videoControllers[_currentPage + 2] == null)) {
    //   _initializeVideoController(_currentPage + 2);
    // }
  }

  void _likeVideo(int index) {
    setState(() {
      _likeCounts[index]++; // Increment like count for the current video
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.videoUrls.length,
            onPageChanged: _onPageChanged,
            scrollDirection: Axis.vertical, // Set the direction to vertical
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  _buildVideoPlayer(index),
                  _buildOverlay(index),
                ],
              );
            },
          ),
          _buildStaticTopBar(),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer(int index) {
    // Check if the video controller is initialized for this index
    if (_videoControllers.length <= index ||
        _videoControllers[index] == null ||
        !_videoControllers[index]!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    // Get the aspect ratio of the current video
    final double aspectRatio = _videoControllers[index]!.value.aspectRatio;

    // VideoPlayer wrapped in an AspectRatio widget to preserve aspect ratio
    return Center(
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: VideoPlayer(_videoControllers[index]!),
      ),
    );
  }

  Widget _buildStaticTopBar() {
    double screenHeight = MediaQuery.of(context).size.height;

    // This widget is always visible and static at the top of the screen
    return Positioned(
      top: screenHeight * 0.005,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Following",
            style: TextStyle(
              color: Colors.white70,
              fontSize: screenHeight * 0.019,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "For You",
            style: TextStyle(
              color: Colors.white,
              fontSize: screenHeight * 0.019,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay(int index) {
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        // Single tap to play/pause video
        setState(() {
          if (_videoControllers[index]!.value.isPlaying) {
            _videoControllers[index]!.pause();
          } else {
            _videoControllers[index]!.play();
          }
        });
      },
      onDoubleTap: () {
        // Double tap to like the video
        _likeVideo(index);
      },
      child: Stack(
        children: [
          // Dark transparent overlay
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          // Bottom content: profile pic, like, comment, share icons
          Positioned(
            bottom: screenHeight * 0.06,
            right: screenHeight * 0.01,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Profile picture in a circular frame
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://images.pexels.com/photos/459225/pexels-photo-459225.jpeg?cs=srgb&dl=daylight-environment-forest-459225.jpg&fm=jpg'), // Replace with actual profile image URL
                  radius: 21,
                ),
                const SizedBox(height: 12),
                _buildBottomIcon(
                    Icons.favorite, "${_likeCounts[index]}"), // Show like count
                const SizedBox(height: 12),
                _buildBottomIcon(Icons.comment, "578"),
                const SizedBox(height: 12),
                _buildBottomIcon(Icons.share, "Share"),
              ],
            ),
          ),
          // Video description, username, and sound info at bottom left
          Positioned(
            bottom: screenHeight * 0.02,
            left: screenHeight * 0.015,
            right: screenHeight * 0.015,
            child: SizedBox(
              width: MediaQuery.of(context).size.width, // Take full width
              child: Align(
                alignment: Alignment.centerLeft, // Align to the right
                child: SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.8, // 80% of the screen width
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '@craig_love',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'The most satisfying job #fyp #satisfying #roadmarking  lhjg skhcdaksjhcbkasjcbkasjcsajk',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign:
                            TextAlign.left, // Align the text to the right
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.music_note, color: Colors.white, size: 10),
                          SizedBox(width: 4),
                          Text(
                            'Roddy Roundicch - The Rou',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildBottomIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 26),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
