import 'package:Pulse/screens/widgets/Explore_widget.dart';
import 'package:Pulse/screens/widgets/component/Notification_Widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for managing system UI overlays
import 'package:Pulse/screens/widgets/swipe_videos_widget.dart';
import 'widgets/home_widget.dart';
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
    const ExplorePage(),
    const ReelPlayerWidget(videoUrls: [
      'https://firebasestorage.googleapis.com/v0/b/tieoda.appspot.com/o/post%2F9QwvEOpJXXM5bn8BjUIP1D6UL6A2%2F344741e3-5fe7-4a98-a1ce-7bb0ac96ab9f%2Fvideo?alt=media&token=e8ac526c-edd0-4118-a813-56781d5fc7f8',
      'https://firebasestorage.googleapis.com/v0/b/tieoda.appspot.com/o/post%2FzJe9VExUpOWFccwKkBg4tHZA7iG2%2F8a84cd5e-a052-4b05-8c55-3d61541c6118%2Fvideo?alt=media&token=cf937739-12fc-4740-839e-c5a8386b6d02',
      'https://getsamplefiles.com/download/mp4/sample-4.mp4',
      'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
      'https://www.w3schools.com/html/mov_bbb.mp4',
      'https://download.samplelib.com/webm/sample-30s.webm',
      'https://onlinetestcase.com/wp-content/uploads/2023/06/15MB.mp4',
    ]),
    NotificationWidget(),
    const ProfileWidget(),
  ];

  @override
  void initState() {
    super.initState();
    // Set up transparent status bar and navigation bar on app start
    _setTransparentUI();
  }

  void _setTransparentUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      systemNavigationBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  void _navigateToAddPostWithAnimation(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddPostWidget(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Slide the widget in from left to right
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(animation);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
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
            // Trigger the animated navigation when swipe threshold is met
            _navigateToAddPostWithAnimation(context);
          }
        }
      },
      onPanStart: (details) {
        dragStart = details.globalPosition.dx;
      },
      child: SafeArea(
        child: Scaffold(
          body: _screens[currentIndex],
          bottomNavigationBar: BottomNavBar(
            currentIndex: currentIndex,
            onTabSelected: (index) {
              setState(() {
                currentIndex = index;
                SystemChrome.setEnabledSystemUIMode(
                    SystemUiMode.edgeToEdge); // Ensure to exit full-screen
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode
        .edgeToEdge); // Exit full-screen mode when the widget is disposed
    super.dispose();
  }
}
