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
        screenHeight * 0.055; // 8% of screen height as an example

    return SizedBox(
      height: navBarHeight, // Adjust the height of the nav bar dynamically
    
      child: BottomNavigationBar(
        
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 25,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.explore,
              size: 25,

            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.play_circle_filled,
              size: 25,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_border_outlined,
              size: 25,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 25,

            ),
            label: '',
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
