import 'package:Pulse/api/apiComponent.dart';
import 'package:Pulse/screens/widgets/component/alert_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProfileScreen extends StatefulWidget {
  final dynamic globalUser;

  const EditProfileScreen({super.key, required this.globalUser});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final dynamic user;

  @override
  void initState() {
    super.initState();
    user = widget.globalUser;
  }

  void copyClipComponent(String value, BuildContext context) {
    Clipboard.setData(ClipboardData(text: value)).then((_) {
      // Show a snackbar or a dialog to indicate the text was copied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to clipboard!')),
      );
    });
  }

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
          'Edit Profile',
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
                _buildProfileOption('Change photo',
                    user['profile_picture'].toString(), screenSize),
              ],
            ),
            const SizedBox(height: 32),
            _buildEditableField(
                'Name', user['full_name'].toString(), screenSize, context),
            _buildEditableField(
                'Username', user['username'].toString(), screenSize, context),
            _buildNonEditableField('pulse.com/@${user['username']}',
                screenSize, context),
            _buildEditableField(
                'Bio',
                user['bio'].toString() == 'null'
                    ? 'Add a bio to your profile'
                    : user['bio'].toString(),
                screenSize,
                context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(String label, String? imageUrl, Size screenSize,
      {bool isVideo = false}) {
    return Column(
      children: [
        CircleAvatar(
          radius: screenSize.width * 0.12,
          backgroundImage: imageUrl == 'null'
              ? const AssetImage('assets/appImages/emptyProfile.jpg')
              : NetworkImage(imageUrl!),
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
                EditDetailScreen(
              title: title,
              initialValue: value,
              userId: user['unique_user_key'],
              prevUsername: user['username'], // Pass the user ID here
            ),
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

  // Non-editable field with the copy button
  Widget _buildNonEditableField(
      String value, Size screenSize, BuildContext context) {
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
              // Call the copyClipComponent to copy the text to clipboard
              copyClipComponent(value, context);
            },
          ),
        ],
      ),
    );
  }
}

class EditDetailScreen extends StatefulWidget {
  final String title;
  final String initialValue;
  final String userId; // Add the userId for API update
  final String prevUsername;
  const EditDetailScreen(
      {super.key,
      required this.title,
      required this.initialValue,
      required this.userId, // Initialize userId
      required this.prevUsername});

  @override
  _EditDetailScreenState createState() => _EditDetailScreenState();
}

class _EditDetailScreenState extends State<EditDetailScreen> {
  late TextEditingController controller;
  bool isUsernameValid = true;
  String errorMessage = '';
  bool showAlert = false;
  bool useraval = false;
  bool newuseraval = false;
  String useravaltxt = "";
  String? prevuser;
  @override
  void initState() {
    super.initState();
    prevuser = widget.prevUsername;
    controller = TextEditingController(text: widget.initialValue);
  }

  Future<void> validateUsername(String username) async {
    if (username.isEmpty) {
      setState(() {
        isUsernameValid = false;
        useraval = false;
        errorMessage = 'Username must not be empty.';
      });
      return;
    }

    // Check if the username contains any spaces
    if (username.contains(' ')) {
      setState(() {
        isUsernameValid = false;
        useraval = false;
        errorMessage = 'Username must not contain spaces.';
      });
      return;
    }

    // Check for minimum length
    if (username.length < 5) {
      setState(() {
        isUsernameValid = false;
        useraval = false;
        errorMessage = 'Username must be at least 5 characters long.';
      });
      return;
    }

    // Check if username matches the previous one
    if (username == prevuser) {
      setState(() {
        isUsernameValid = true;
        useravaltxt = "current username";
        useraval = true;
        errorMessage = '';
      });
      return;
    }

    // Check availability of the username
    final result = await checkUsername(username: username);

    if (result.containsKey('error')) {
      setState(() {
        isUsernameValid = false;
        useraval = false;
        errorMessage = result['error'];
      });
    } else if (result['available'] == false) {
      setState(() {
        useraval = false;
        isUsernameValid = result['available'];
        errorMessage = 'username is already taken';
      });
    } else {
      setState(() {
        isUsernameValid = result['available'];
        useraval = true;
        useravaltxt = "available";
        newuseraval = true;
        errorMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'Edit ${widget.title}',
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
            // TextField for input
            Row(
              children: [
                // Show tick/cross icon based on username validity
                if (widget.title == 'Username') ...[
                  Icon(
                    isUsernameValid ? Icons.check : Icons.close,
                    color: isUsernameValid ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        hintText: 'Enter new ${widget.title}',
                        errorText: isUsernameValid ? null : errorMessage,
                        labelText: useraval ? useravaltxt : null,
                        labelStyle: const TextStyle(color: Colors.green)),
                    onChanged: (value) {
                      if (widget.title == 'Username') {
                        validateUsername(value); // Validate username on change
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Save button
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  fixedSize: Size(screenSize.width * 0.35, 50),
                  side:
                      const BorderSide(color: Color.fromARGB(255, 100, 99, 99)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () async {
                  // Handle saving the new value
                  String updatedValue = controller.text;

                  if (!isUsernameValid) {
                    setState(() {
                      showAlert = true; // Show alert if username is invalid
                    });
                    return;
                  }

                  // Update the profile based on the title
                  if (widget.title == 'Name') {
                    await updateUserProfile(
                        widget.userId, updatedValue, '', '');
                  } else if (widget.title == 'Username') {
                    await updateUserProfile(
                        widget.userId, '', updatedValue, '');
                  } else if (widget.title == 'Bio') {
                    await updateUserProfile(
                        widget.userId, '', '', updatedValue);
                  }

                  Navigator.of(context)
                      .pop(updatedValue); // Pass the new value back
                },
                child: const Text('Save'),
      ),
             
          ],
        ),
      ),
      // Alert Message Component
      floatingActionButton: showAlert
          ? AlertMessage(
              heading: 'Invalid Username',
              message: errorMessage,
              setShowAlert: (value) {
                setState(() {
                  showAlert = value;
                });
              },
              showAlert: showAlert,
              triggerFunction: () {
                setState(() {
                  showAlert = false;
                });
              },
            )
          : null,
    );
  }
}
