import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'widgets/component/alert_message.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:intl/intl.dart'; 
class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController emailOrPhoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  String step = "enterPhoneOrEmail";
  bool showPassword = false;
  String? profileImagePath;
  bool showAlert = false;
  String alertHeading = "";
  String alertMessage = "";

  final RegExp emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  final RegExp phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');

  void togglePasswordVisibility() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  Future<void> pickImage() async {
    var status = await Permission.storage.request();

    if (status.isGranted) {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          profileImagePath = pickedFile.path;
        });
      } else {
        showAlertDialog("No Image Selected", "Please select an image.");
      }
    } else if (status.isDenied || status.isPermanentlyDenied) {
      showAlertDialog("Permission Denied",
          "Storage access permission is required to pick an image.");
    }
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signIn();
      // Handle user information after sign-in
    } catch (error) {
      showAlertDialog("Google Sign-In Failed", "Please try again.");
    }
  }
bool isValidDOB(String dob) {
  try {
    // Parse the date using strict parsing to ensure format is correct
    final parsedDate = DateFormat('yyyy-MM-dd').parseStrict(dob);
    final currentDate = DateTime.now();
    
    // Check if the date is in the future
    if (parsedDate.isAfter(currentDate)) {
      showAlertDialog("Invalid DOB", "Date of birth cannot be in the future.");
      return false;
    }
    
    // Calculate the age
    int age = currentDate.year - parsedDate.year;
    
    // Adjust age if the birthday has not occurred this year yet
    if (currentDate.month < parsedDate.month ||
        (currentDate.month == parsedDate.month && currentDate.day < parsedDate.day)) {
      age--;
    }
    
    // Check if the user is at least 13 years old
    if (age < 13) {
      showAlertDialog("Invalid DOB", "You must be at least 13 years old.");
      return false;
    }
    
    return true; // Valid DOB
  } catch (e) {
    // Handle parsing error
    showAlertDialog("Invalid DOB", "Please enter a valid date (YYYY-MM-DD).");
    return false;
  }
}

  Future<void> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        // Handle user information after sign-in
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
    } catch (error) {
      showAlertDialog("Apple Sign-In Failed", "Please try again.");
    }
  }

  void handleNextStep() {
    if (step == "enterPhoneOrEmail") {
      if (emailRegex.hasMatch(emailOrPhoneController.text) ||
          phoneRegex.hasMatch(emailOrPhoneController.text)) {
        setState(() {
          step = "enterOTP";
        });
      } else {
        showAlertDialog(
            "Invalid Input", "Please enter a valid email or phone number.");
      }
    } else if (step == "enterOTP") {
      if (otpController.text.isNotEmpty) {
        setState(() {
          step = "enterPassword";
        });
      } else {
        showAlertDialog(
            "Missing OTP", "Please enter the OTP sent to your email or phone.");
      }
    } else if (step == "enterPassword") {
      if (passwordController.text.isNotEmpty) {
        setState(() {
          step = "enterPersonalDetails";
        });
      } else {
        showAlertDialog("Missing Password", "Please create a password.");
      }
    } else if (step == "enterPersonalDetails") {
      if (firstNameController.text.isNotEmpty &&
          lastNameController.text.isNotEmpty &&
          isValidDOB(dobController.text)) {
        // Proceed to home screen
        Navigator.pushNamed(context, '/Home');
      } else {
        showAlertDialog("Incomplete Details",
            "Please fill in your first and last name and enter a valid date of birth.");
      }
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
        backgroundColor: Colors.white,
        title: Text(
          step == "enterPhoneOrEmail"
              ? "Sign Up"
              : step == "enterOTP"
                  ? "Verify"
                  : step == "enterPassword"
                      ? "Password"
                      : "Personal Details",
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (step == "enterPhoneOrEmail") {
              Navigator.pop(context);
            } else if (step == "enterOTP") {
              setState(() {
                step = "enterPhoneOrEmail";
              });
            } else if (step == "enterPassword") {
              setState(() {
                step = "enterOTP";
              });
            } else if (step == "enterPersonalDetails") {
              setState(() {
                step = "enterPassword";
              });
            }
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (step == "enterPhoneOrEmail") ...[
                  buildTextInput(
                      controller: emailOrPhoneController,
                      hintText: "Phone or Email"),
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
                  // const SizedBox(height: 10),
                  // buildSocialSignInButton(
                  //   context: context,
                  //   onPressed: signInWithApple,
                  //   image: 'assets/appImages/icon/apple.png',
                  //   label: 'Sign in with Apple',
                  // ),
                ] else if (step == "enterOTP") ...[
                  buildTextInput(
                      controller: otpController, hintText: "Enter OTP"),
                ] else if (step == "enterPassword") ...[
                  buildPasswordInput(),
                ] else if (step == "enterPersonalDetails") ...[
                  GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: profileImagePath != null
                          ? FileImage(File(profileImagePath!))
                          : const AssetImage(
                                  'assets/appImages/emptyProfile.jpg')
                              as ImageProvider,
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildTextInput(
                      controller: firstNameController, hintText: "First Name"),
                  buildTextInput(
                      controller: lastNameController, hintText: "Last Name"),
                  buildTextInput(
                      controller: dobController,
                      hintText: "Date of Birth (YYYY-MM-DD)"),
                  buildTextInput(
                      controller: genderController,
                      hintText: "Gender (Optional)"),
                ],
                const SizedBox(height: 20),
                Material(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: handleNextStep,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        step == "enterPhoneOrEmail"
                            ? "Next"
                            : step == "enterOTP"
                                ? "Verify"
                                : step == "enterPassword"
                                    ? "Submit"
                                    : "Save",
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: "Roboto-Medium",
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
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
        obscureText: !showPassword,
        decoration: InputDecoration(
          hintText: "Create Password",
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFCECECE)),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: const Color(0xFFE8E8E8),
          suffixIcon: IconButton(
            icon: Icon(
              showPassword ? Icons.visibility_off : Icons.visibility,
              color: const Color(0xFF888888),
            ),
            onPressed: togglePasswordVisibility,
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
      borderRadius: BorderRadius.circular(50),
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
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, height: 24),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
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
