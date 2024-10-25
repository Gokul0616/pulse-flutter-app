import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for managing system UI overlays
import 'package:Pulse/screens/widgets/swipe_videos_widget.dart';
import 'widgets/home_widget.dart';
import 'widgets/search_widget.dart';
import 'widgets/chat_widget.dart';
import 'widgets/profile_widget.dart';
import 'widgets/bottomNavbar/bottom_nav_bar.dart';
import './widgets/component/add_post_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userId = '12345';
  int currentIndex = 0;
  double dragStart = 0;

  final List<Widget> _screens = [
    const HomeWidget(),
    const SearchWidget(),
    const ReelPlayerWidget(videoUrls: [
      'https://firebasestorage.googleapis.com/v0/b/tieoda.appspot.com/o/post%2F9QwvEOpJXXM5bn8BjUIP1D6UL6A2%2F344741e3-5fe7-4a98-a1ce-7bb0ac96ab9f%2Fvideo?alt=media&token=e8ac526c-edd0-4118-a813-56781d5fc7f8',
      'https://firebasestorage.googleapis.com/v0/b/tieoda.appspot.com/o/post%2FzJe9VExUpOWFccwKkBg4tHZA7iG2%2F8a84cd5e-a052-4b05-8c55-3d61541c6118%2Fvideo?alt=media&token=cf937739-12fc-4740-839e-c5a8386b6d02',
      'https://getsamplefiles.com/download/mp4/sample-4.mp4',
      'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
      'https://www.w3schools.com/html/mov_bbb.mp4',
      'https://download.samplelib.com/webm/sample-30s.webm',
      'https://onlinetestcase.com/wp-content/uploads/2023/06/15MB.mp4',
    ]),
    const ChatListScreen(),
    const ProfileWidget(),
  ];

  @override
  void initState() {
    super.initState();
    // Set up transparent status bar and navigation bar on app start
    _setTransparentUI();
  }

  // Function to make status and navigation bars transparent
  void _setTransparentUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make status bar transparent
      systemNavigationBarColor: Colors.black, // Make navigation bar transparent
      statusBarIconBrightness:
          Brightness.light, // Change this based on light/dark theme
      systemNavigationBarIconBrightness:
          Brightness.light, // Change this based on theme
    ));
  }

  // You can still keep these full-screen-related functions if you need to toggle modes later
  // Function to enter full-screen mode (optional, you might not need it)
  void _enterFullScreenMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  // Function to exit full-screen mode (optional)
  void _exitFullScreenMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _setTransparentUI(); // Reset back to transparent UI when exiting full-screen
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double swipeThreshold = screenWidth / 4;

    return GestureDetector(
      onPanUpdate: (details) {
        if (currentIndex == 0) {
          if (details.delta.dx > 0 &&
              details.globalPosition.dx - dragStart > swipeThreshold) {
            // Swipe from left to right, covering the threshold distance
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddPostWidget()),
            );
          }
        }
      },
      onPanStart: (details) {
        dragStart = details.globalPosition.dx;
      },
      child: SafeArea(
        // Ensures safe layout around status bar and navigation bar
        child: Scaffold(
          body: _screens[currentIndex],
          bottomNavigationBar: BottomNavBar(
            currentIndex: currentIndex,
            onTabSelected: (index) {
              setState(() {
                currentIndex = index;
                _exitFullScreenMode(); // Ensure to exit full-screen when switching tabs
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _exitFullScreenMode(); // Exit full-screen mode when the widget is disposed
    super.dispose();
  }
}
