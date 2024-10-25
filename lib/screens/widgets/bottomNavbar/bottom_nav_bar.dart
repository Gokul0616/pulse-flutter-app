import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Get the height of the screen
    double screenHeight = MediaQuery.of(context).size.height;

    // Adjust the height of the BottomNavigationBar based on screen size
    double navBarHeight =
        screenHeight * 0.065; // 8% of screen height as an example

    return SizedBox(
      height: navBarHeight, // Adjust the height of the nav bar dynamically
    
      child: BottomNavigationBar(
        
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 20,
            ),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 20,
            ),
            label: 'Search',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_filled, size: 20),
            label: 'Reel',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 15, // Set the desired width
              height: 15, // Set the desired height
              child: Image.asset(
                'assets/appImages/icon/chat_icon.png', // Replace with your image path
                color: currentIndex == 3
                    ? Colors.black
                    : Colors.grey, // Change color based on selection
              ),
            ),
            label: 'Chat',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 20,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: currentIndex,
        onTap: onTabSelected,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
