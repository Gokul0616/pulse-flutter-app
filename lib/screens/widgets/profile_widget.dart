import 'package:Pulse/api/apiComponent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:Pulse/screens/widgets/component/edit_profile_screen.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final storage = const FlutterSecureStorage();


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.person_add_alt, color: Colors.black),
          onPressed: () {
            // Add functionality for the person add icon
          },
        ),
        actions: [
          // Use Builder widget to get the correct context for the Scaffold
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu_rounded, color: Colors.black),
                onPressed: () {
                  // Open the right-side drawer when pressed
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
        centerTitle: true,
        title: const Text(
          'Jacob West',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: const NetworkImage(
                  'https://th.bing.com/th/id/OIP.MtGd0GcHiXFMqidnBh8UngHaE8?rs=1&pid=ImgDetMain'),
              radius: screenSize.width * 0.1,
            ),
            const Text(
              'jacob_w',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Text(
              '@jacob_w',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCountColumn('14', 'Following'),
                _buildDivider(),
                _buildCountColumn('38', 'Followers'),
                _buildDivider(),
                _buildCountColumn('91', 'Likes'),
              ],
            ),
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
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
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
                  side:
                      const BorderSide(color: Color.fromARGB(255, 100, 99, 99)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                ),
                child: const Text(
                  'Edit profile',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tap to add bio',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.grid_on, size: 20)),
                Tab(icon: Icon(Icons.notes, size: 20)),
                Tab(icon: Icon(Icons.video_library, size: 20)),
              ],
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  _PostTab(),
                  _Tweakstab(),
                  _VideosTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      // Change 'drawer' to 'endDrawer' here to open the drawer from the right
      endDrawer: Drawer(
        shape: const RoundedRectangleBorder(
          // This removes the curved borders
          borderRadius:
              BorderRadius.zero, // Ensure the corners are square (no rounding)
        ),
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // const DrawerHeader(
            //   decoration: BoxDecoration(),
            //   child: Text(
            //     'Social Media App',
            //     style: TextStyle(
            //       color: Colors.black,
            //       fontSize: 24,
            //     ),
            //   ),
            // ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                // Navigate to Profile screen
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Navigate to Settings screen
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () async {
                await logout();
                Navigator.pushReplacementNamed(context, '/auth');
              },
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // Divider widget between each stat (Following, Followers, Likes)
  Widget _buildDivider() {
    return const SizedBox(
      width: 24,
    );
  }
}

class _PostTab extends StatelessWidget {
  const _PostTab();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(4.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        childAspectRatio: 1,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[300],
            image: const DecorationImage(
              image: NetworkImage('https://via.placeholder.com/300'),
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
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
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
              size: 40,
            ),
          ),
        );
      },
    );
  }
}
