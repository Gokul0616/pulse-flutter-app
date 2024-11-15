import 'package:Pulse/screens/widgets/chat_widget.dart';
import 'package:Pulse/screens/widgets/component/tweaks_widget.dart';
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
              Colors.white, // Dynamically change the background color
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
              icon: const ImageIcon(
                AssetImage('assets/appImages/icon/chat_icon.png'),
                size: 26,
                color: Colors.black, // Set color if your image supports tinting
              ),
              onPressed: () {
                // Navigate to ChatListScreen with a left-to-right swipe animation
                Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const ChatListScreen();
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    // Define the left-to-right swipe animation
                    const begin = Offset(1.0, 0.0); // Start from the right
                    const end = Offset.zero; // End at the current position
                    const curve = Curves.easeInOut; // Animation curve

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                        position: offsetAnimation, child: child);
                  },
                ));
              },
            ),
          ]

      ),
      body: ListView(
        controller: _scrollController, // Attach scroll controller to ListView
        children: [
          TweakWidget(
            userName: "John Doe",
            handle: "johndoe",
            timeAgo: "2h",
            userProfileUrl:
                "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            tweakContent: "This is a sample tweak content!",
            tweakImageUrl:
                "https://images.pexels.com/photos/417074/pexels-photo-417074.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
            isLiked: false,
            likeCount: 123,
            commentCount: 45,
            retweakCount: 20,
            onLikeToggle: () {
              // Toggle like action
            },
            onCommentPressed: () {
              // Navigate to comments
            },
            onRetweakPressed: () {
              // Retweak action
            },
            onSharePressed: () {
              // Share action
            },
          ),
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
          Container(
            child: VideoListScreen(
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
              onVideoClicked: (VideoItem) {},
            ),
          ),
          PostWidget(
            userName: "Username",
            postTime: "10 minutes ago",
            userProfileUrl:
                "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            postUrl:
                "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_640.jpg",
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
          TweakWidget(
            userName: "John Doe",
            handle: "johndoe",
            timeAgo: "2h",
            userProfileUrl:
                "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            tweakContent:
                "Your new home for real-time updates, quick thoughts, and engaging conversations. Share your thoughts, connect with others, and tweak the world around you.",
            tweakImageUrl:
                "https://images.pexels.com/photos/417074/pexels-photo-417074.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
            isLiked: false,
            likeCount: 123,
            commentCount: 45,
            retweakCount: 20,
            onLikeToggle: () {
              // Toggle like action
            },
            onCommentPressed: () {
              // Navigate to comments
            },
            onRetweakPressed: () {
              // Retweak action
            },
            onSharePressed: () {
              // Share action
            },
          ),
          TweakWidget(
            userName: "John Doe",
            handle: "johndoe",
            timeAgo: "2h",
            userProfileUrl:
                "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            tweakContent:
                "You're part of something new and exciting!Since Tweaks is in its early stages, your feedback is crucial. Explore the features, test everything, and let us know what you think. Your tweaks are what will make this platform better!",
            tweakImageUrl:
                "https://images.pexels.com/photos/417074/pexels-photo-417074.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
            isLiked: false,
            likeCount: 123,
            commentCount: 45,
            retweakCount: 20,
            onLikeToggle: () {
              // Toggle like action
            },
            onCommentPressed: () {
              // Navigate to comments
            },
            onRetweakPressed: () {
              // Retweak action
            },
            onSharePressed: () {
              // Share action
            },
          ),
        ],
      ),
    );

  }
}
