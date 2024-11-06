import 'package:flutter/material.dart';
import 'component/post_widget.dart';
import 'package:Pulse/screens/widgets/component/VideoListScreen_widget.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  bool isLiked = false; // Track if the post is liked
  final ScrollController _scrollController = ScrollController();
  Color _appBarBackgroundColor = Colors.white; // Initial background color

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // double scrollOffset = _scrollController.position.pixels;
      setState(() {
        // Update the color based on scroll position
        _appBarBackgroundColor = const Color.fromARGB(255, 255, 255, 255);
        // scrollOffset > 50 ? Colors.white : Colors.white;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:
            _appBarBackgroundColor, // Dynamically change the background color
        title: Row(
          children: [
            Image.asset(
              'assets/appImages/icon/icon.png', // Update this with your icon's path
              width: 55, // Adjust the width as needed
              height: 55, // Adjust the height as needed
              color: Colors.black, // Change icon color
            ),
            const Text(
              "Pulse",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors
                      .black // Color remains static or you can change it too
                  ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border_outlined),
            color: Colors.black,
            iconSize: 26,
            onPressed: () {
              // Navigate to direct messages (optional)
            },
          ),
        ],
      ),
      body: ListView(
        controller: _scrollController, // Attach scroll controller to ListView
        children: [
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
          // Add more PostWidgets here
          Container(
            child: VideoListScreen(
              videoItems: [
                VideoItem(
                  url: 'https://download.samplelib.com/webm/sample-30s.webm',
                  thumbnailUrl:
                      'https://via.placeholder.com/120x90.png?text=Thumbnail1',
                  title: 'Sample Video 1',
                  channelName: 'Channel 1',
                  duration: '3:45',
                ),
                // Add more VideoItem objects as needed
              ],
              onVideoClicked: (VideoItem) {},
            ),
          ),
          Container(
            child: VideoListScreen(
              videoItems: [
                VideoItem(
                  url:
                      'https://onlinetestcase.com/wp-content/uploads/2023/06/15MB.mp4',
                  thumbnailUrl:
                      'https://via.placeholder.com/120x90.png?text=Thumbnail1',
                  title: 'Sample Video 2',
                  channelName: 'Channel 1',
                  duration: '3:45',
                ),
                // Add more VideoItem objects as needed
              ],
              onVideoClicked: (VideoItem) {},
            ),
          ),
          Container(
            child: VideoListScreen(
              videoItems: [
                VideoItem(
                  url: 'https://www.w3schools.com/html/mov_bbb.mp4',
                  thumbnailUrl:
                      'https://via.placeholder.com/120x90.png?text=Thumbnail1',
                  title: 'Sample Video 3',
                  channelName: 'Channel 1',
                  duration: '3:45',
                ),
                // Add more VideoItem objects as needed
              ],
              onVideoClicked: (VideoItem) {},
            ),
          ),
          Container(
            child: VideoListScreen(
              videoItems: [
                VideoItem(
                  url: 'https://getsamplefiles.com/download/mp4/sample-4.mp4',
                  thumbnailUrl:
                      'https://via.placeholder.com/120x90.png?text=Thumbnail1',
                  title: 'Sample Video 4',
                  channelName: 'Channel 1',
                  duration: '3:45',
                ),
                // Add more VideoItem objects as needed
              ],
              onVideoClicked: (VideoItem) {},
            ),
          ),
        ],
      ),
    );
 
  }
}
