import 'package:Pulse/screens/widgets/component/edit_profile_screen.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // No shadow for a clean look
        leading: IconButton(
          icon: const Icon(Icons.person_add_alt, color: Colors.black),
          onPressed: () {
            // Add functionality for the person add icon
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Add functionality for more options icon
            },
          ),
        ],
        centerTitle: true,
        title: const Text(
          'Jacob West', // Static username, could be dynamic
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: DefaultTabController(
        
        length: 3, // Number of tabs
        
        child: Column(
          children: [
            // const SizedBox(height: 4),
            CircleAvatar(
              backgroundImage: const NetworkImage(
                  'https://th.bing.com/th/id/OIP.MtGd0GcHiXFMqidnBh8UngHaE8?rs=1&pid=ImgDetMain'),
              radius: screenSize.width * 0.1, // Adjusted size of avatar
            ),
            // const SizedBox(height: 8),
            const Text(
              'jacob_w',
              style: TextStyle(
                fontSize: 16, // Slightly larger for username
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            // const SizedBox(height: 3),
            const Text(
              '@jacob_w', // Handle with a lighter style
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            // const SizedBox(height: 12),
            // Following, Followers, Likes section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCountColumn('14', 'Following'),
                _buildDivider(), // Divider between each stat
                _buildCountColumn('38', 'Followers'),
                _buildDivider(),
                _buildCountColumn('91', 'Likes'),
              ],
            ),
            const SizedBox(height: 4),
            // Edit profile button, styled to match the image
            SizedBox(
              width: screenSize.width * 0.35,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const EditProfileScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0); // Start from the right
                        const end = Offset.zero; // End at the original position
                        const curve = Curves.easeInOut;

                        final tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        final offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                      color: Color.fromARGB(255, 100, 99, 99)), // Border color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 8,horizontal: 8), // Vertical padding
                ),
                child: const Text(
                  'Edit profile',
                  style: TextStyle(
                    color:
                        Colors.black, // Change text color to black for contrast
                    fontSize: 16, // Adjust font size if necessary
                  ),
                ),
              ),
            ),

            const SizedBox(height: 6),
            // Placeholder for bio
            const Text(
              'Tap to add bio',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            // Tab Bar for navigating between sections
            const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.grid_on, size: 20)), // Posts Tab
                Tab(icon: Icon(Icons.notes, size: 20)), // Likes Tab
                Tab(icon: Icon(Icons.video_library, size: 20)), // Videos Tab
              ],
              labelColor: Colors.black, // Color of selected tab
              unselectedLabelColor: Colors.grey, // Color of unselected tabs
              indicatorColor: Colors.blue, // Color of the tab indicator
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  _PostTab(), // Content for Posts
                  _Tweakstab(), // Content for Likes
                  _VideosTab(), // Content for Videos
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for building the stat columns (Following, Followers, Likes)
  Widget _buildCountColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 16, // Adjusted for a cleaner look
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14, // Reduced size of the label
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // Divider widget between each stat (Following, Followers, Likes)
  Widget _buildDivider() {
    return const SizedBox(
      width: 24, // Adjust space between each count
    );
  }
}

// Remaining classes (_PostTab, _Tweakstab, _VideosTab) unchanged

class _PostTab extends StatelessWidget {
  const _PostTab();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(4.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 columns like TikTok
        crossAxisSpacing: 4.0, // Spacing between grid items
        mainAxisSpacing: 4.0,
        childAspectRatio: 1, // Ensures square aspect ratio
      ),
      itemCount: 12, // Number of posts (replace with dynamic data later)
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[300], // Placeholder for post thumbnail
            image: const DecorationImage(
              image: NetworkImage(
                  'https://via.placeholder.com/300'), // Placeholder image
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

class _Tweakstab extends StatelessWidget {
  const _Tweakstab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: 10, // Number of liked items (replace with dynamic data later)
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4, // Added elevation for shadow effect
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Tweak: Item ${index + 1}: This is a sample like.',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}

class _VideosTab extends StatelessWidget {
  const _VideosTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: 5, // Number of videos (replace with dynamic data later)
      itemBuilder: (context, index) {
        return Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black, // Placeholder for video
            borderRadius: BorderRadius.circular(12), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          margin: const EdgeInsets.only(bottom: 10.0),
          child: const Center(
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 40, // Smaller icon size
            ),
          ),
        );
      },
    );
  }
}
