import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
        centerTitle: true,
        title: const Text(
          'Edit Profile', // Title of the screen
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
      
        child: Column(
          
          children: [
            
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Change photo button
                _buildProfileOption(
                    'Change photo',
                    'https://th.bing.com/th/id/OIP.MtGd0GcHiXFMqidnBh8UngHaE8?rs=1&pid=ImgDetMain',
                    screenSize),
                const SizedBox(width: 48), // Spacing between photo and video
                // Change video button
                _buildProfileOption('Change video', null, screenSize,
                    isVideo: true),
              ],
            ),
            const SizedBox(height: 32),
            // Editable fields for Name, Username, Bio, and Social Links
            _buildEditableField('Name', 'Jacob West', screenSize, context),
            _buildEditableField('Username', 'jacob_w', screenSize, context),
            _buildNonEditableField('tiktok.com/@jacob_w', screenSize),
            _buildEditableField(
                'Bio', 'Add a bio to your profile', screenSize, context),
            const Divider(thickness: 1), // Divider between Bio and social links
            _buildEditableField('Instagram', 'Add Instagram to your profile',
                screenSize, context),
            _buildEditableField(
                'YouTube', 'Add YouTube to your profile', screenSize, context),
          ],
        ),
      ),
    );
  }

  // Method to build the profile option (Change Photo/Video)
  Widget _buildProfileOption(String label, String? imageUrl, Size screenSize,
      {bool isVideo = false}) {
    return Column(
      children: [
        CircleAvatar(
          radius: screenSize.width * 0.12,
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
          backgroundColor: imageUrl == null ? Colors.grey[300] : null,
          child: isVideo
              ? const Icon(Icons.videocam, color: Colors.black, size: 30)
              : null,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // Helper function to build editable fields
  Widget _buildEditableField(
      String title, String value, Size screenSize, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.06),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(color: Colors.grey),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                EditDetailScreen(title: title, initialValue: value),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0); // Start from the right
              const end = Offset.zero; // End at the original position
              const curve = Curves.easeInOut;

              final tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              final offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      },
    );
  }

  // Helper function to build non-editable fields (like the TikTok profile link)
  Widget _buildNonEditableField(String value, Size screenSize) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.06),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, color: Colors.grey, size: 16),
            onPressed: () {
              // Add copy functionality here
            },
          ),
        ],
      ),
    );
  }
}

// New screen for editing details
class EditDetailScreen extends StatelessWidget {
  final String title;
  final String initialValue;

  const EditDetailScreen(
      {super.key, required this.title, required this.initialValue});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: initialValue);
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
        centerTitle: true,
        title: Text(
          'Edit $title',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(hintText: 'Enter new $title'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              
              style: OutlinedButton.styleFrom(
                fixedSize: Size(screenSize.width * 0.35, 50), // Fixed width
                side: const BorderSide(
                    color: Color.fromARGB(255, 100, 99, 99)), // Border color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 12), // Vertical padding
              ).copyWith(
                foregroundColor: WidgetStateProperty.all(
                    Colors.black), // Change text color
              ),
              onPressed: () {
                // Handle saving the new value
                Navigator.of(context)
                    .pop(controller.text); // Pass the new value back
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
