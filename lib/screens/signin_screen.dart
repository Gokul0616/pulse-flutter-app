import 'package:flutter/material.dart';
import 'widgets/component/alert_message.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailOrPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool showPassword = false; // State to control password visibility
  bool showAlert = false;
  String alertHeading = "";
  String alertMessage = "";

  final RegExp emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  final RegExp phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');

  void togglePasswordVisibility() {
    setState(() {
      showPassword = !showPassword; // Toggle the password visibility
    });
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signIn();
      // Handle user information after sign-in
      Navigator.pushNamed(context, '/Home'); // Navigate to Home
    } catch (error) {
      showAlertDialog("Google Sign-In Failed", "Please try again.");
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        // Handle user information after sign-in
        Navigator.pushNamed(context, '/Home'); // Navigate to Home
      } else {
        showAlertDialog("Facebook Sign-In Failed", "Please try again.");
      }
    } catch (error) {
      showAlertDialog("Facebook Sign-In Failed", "Please try again.");
    }
  }

  Future<void> signInWithApple() async {
    try {
      // final appleIDCredential = await SignInWithApple.getAppleIDCredential(
      //   scopes: [
      //     AppleIDAuthorizationScopes.email,
      //     AppleIDAuthorizationScopes.fullName,
      //   ],
      // );
      // Handle user information after sign-in
      Navigator.pushNamed(context, '/Home'); // Navigate to Home
    } catch (error) {
      showAlertDialog("Apple Sign-In Failed", "Please try again.");
    }
  }

  void handleSignIn() {
    if (emailRegex.hasMatch(emailOrPhoneController.text) ||
        phoneRegex.hasMatch(emailOrPhoneController.text)) {
      if (passwordController.text.isNotEmpty) {
        // Proceed to home screen
        Navigator.pushNamed(context, '/Home');
      } else {
        showAlertDialog("Missing Password", "Please enter your password.");
      }
    } else {
      showAlertDialog(
          "Invalid Input", "Please enter a valid email or phone number.");
    }
  }

  void showAlertDialog(String heading, String message) {
    FocusScope.of(context).unfocus();
    setState(() {
      showAlert = true;
      alertHeading = heading;
      alertMessage = message;
    });
  }

  void closeAlertDialog() {
    setState(() {
      showAlert = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildTextInput(
                    controller: emailOrPhoneController,
                    hintText: "Phone or Email"),
                const SizedBox(height: 20),
                buildPasswordInput(),
                const SizedBox(height: 20),
                Material(
                  borderRadius: BorderRadius.circular(8), // Match button shape
                  color: Colors.transparent, // Makes Material transparent
                  child: InkWell(
                    onTap: handleSignIn,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      decoration: BoxDecoration(
                        color: Colors.white, // Button background color
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // Changes position of shadow
                          ),
                        ],
                      ),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Roboto-Medium",
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                buildSocialSignInButton(
                  context: context,
                  onPressed: signInWithGoogle,
                  image: 'assets/appImages/icon/google.png',
                  label: 'Sign in with Google',
                ),
                const SizedBox(height: 10),
                buildSocialSignInButton(
                  context: context,
                  onPressed: signInWithFacebook,
                  image: 'assets/appImages/icon/facebook.png',
                  label: 'Sign in with Facebook',
                ),
                const SizedBox(height: 10),
                buildSocialSignInButton(
                  context: context,
                  onPressed: signInWithApple,
                  image: 'assets/appImages/icon/apple.png',
                  label: 'Sign in with Apple',
                ),
              ],
            ),
          ),
          if (showAlert)
            AlertMessage(
              heading: alertHeading,
              message: alertMessage,
              setShowAlert: (bool value) {
                closeAlertDialog();
              },
              showAlert: showAlert,
              isRight: false,
              rightButtonText: "OK",
              triggerFunction: () {
                closeAlertDialog();
              },
            ),
        ],
      ),
    );
  }

  Widget buildTextInput({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFCECECE)),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: const Color(0xFFE8E8E8),
        ),
      ),
    );
  }

  Widget buildPasswordInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: passwordController,
        obscureText: !showPassword, // Toggle password visibility
        decoration: InputDecoration(
          hintText: "Password",
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFCECECE)),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: const Color(0xFFE8E8E8),
          suffixIcon: IconButton(
            icon: Icon(
              showPassword
                  ? Icons.visibility_off
                  : Icons.visibility, // Eye icon
              color: const Color(0xFF000000), // Icon color
            ),
            onPressed:
                togglePasswordVisibility, // Toggle password visibility on press
          ),
        ),
      ),
    );
  }

  Widget buildSocialSignInButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required String image,
    required String label,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(
          50), // Make sure the ripple effect respects the rounded corners
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // Changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, height: 24), // Image on the left
            const SizedBox(width: 10), // Space between image and text
            Text(
              label,
              style: const TextStyle(
                color: Colors.black, // Black color for text
                fontSize: 16,
                fontFamily: "Roboto-Medium",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
