
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Force light status bar
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
    );

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/appImages/HomeImage.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay with content
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              // Center the column
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center vertically
                children: [
                  // App Icon
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: const CircleAvatar(
                      radius: 45,
                      backgroundImage:
                          AssetImage('assets/appImages/icon/icon.png'),
                      backgroundColor: Colors.black ,
                    ),
                  ),
                  // Sign In Buttons
                  AuthButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signin');
                    },
                    iconPath: 'assets/appImages/icon/iphone.png',
                    label: 'Sign In with Phone Number',
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    iconColor: Colors.white,
                  ),
                  AuthButton(
                    onPressed: () {},
                    iconPath: 'assets/appImages/icon/google.png',
                    label: 'Sign In with Google',
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    iconColor: null, // Keep the Google logo color
                  ),
                  AuthButton(
                    onPressed: () {},
                    iconPath: 'assets/appImages/icon/facebook.png',
                    label: 'Sign In with Facebook',
                    backgroundColor: const Color(0xFF1877F2),
                    textColor: Colors.white,
                    iconColor: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  // Separator
                  const Text(
                    'or',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  // Sign Up Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width *
                          0.85, // Full width
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: RichText(
                        text: const TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Roboto-Medium',
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF4757),
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center, // Center the text
                      ),
                    ),
                  ),
                  // Terms and Conditions
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      children: [
                        const Text(
                          'By signing up you agree to our',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto-Medium',
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Handle terms navigation
                          },
                          child: const Text(
                            'Terms and Conditions',
                            style: TextStyle(
                              color: Color(0xFF71B9F0),
                              fontFamily: 'Roboto-Light',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class AuthButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color? iconColor;

  const AuthButton({super.key, 
    required this.iconPath,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30), // Match the button shape
      splashColor: Colors.grey.withOpacity(0.5), // Color of the ripple effect
      highlightColor:
          Colors.transparent, // Optional: Make the highlight color transparent
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        width: MediaQuery.of(context).size.width * 0.85, // Full width
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content
          children: [
            Image.asset(
              iconPath,
              width: 25,
              height: 25,
              color: iconColor,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontFamily: 'Roboto-Medium',
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
