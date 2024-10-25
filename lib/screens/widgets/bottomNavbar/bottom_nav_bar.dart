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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_filled, size: 42),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width:  24, // Set the desired width
              height:  24, // Set the desired height
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
            icon: Icon(Icons.person),
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
