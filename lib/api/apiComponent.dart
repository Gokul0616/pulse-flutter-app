import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mime/mime.dart';

const commonUrl = 'http://10.0.2.2:5000/api';
// const commonUrl = 'https://pulse-flutter-app-server.onrender.com/api';
const storage = FlutterSecureStorage();

// Function to save the token after login/signup
Future<void> saveUserToken(String token) async {
  await storage.write(key: 'user_token_pulseApp', value: token);
}

//Future<void> logout() async {
//await storage.delete(key: 'user_token');
// Navigator.pushReplacementNamed(context, '/');
//}
Future<void> logout() async {
  await storage.delete(key: 'user_token_pulseApp');
}

Future<dynamic> PhoneOrEmailValidateApi({String? email, String? phone}) async {
  // Ensure at least one parameter is provided
  if ((email == null || email.isEmpty) && (phone == null || phone.isEmpty)) {
    return {"error": "Either 'email' or 'phone' must be provided."};
  }

  final url = Uri.parse('$commonUrl/PhoneOrEmailValidate');

  try {
    // Construct JSON payload dynamically
    Map<String, String> requestData = {};
    if (email != null && email.isNotEmpty) requestData['email'] = email;
    if (phone != null && phone.isNotEmpty) requestData['phone'] = phone;

    // Make POST request
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestData),
    );

    // Check for successful response
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse; // Return decoded JSON response
    } else {
      return {
        "error": "Failed to sign up",
        "statusCode": response.statusCode,
        "body": response.body
      };
    }
  } catch (e) {
    return {"error": "Exception occurred", "details": e.toString()};
  }
}

// Function to upload profile image with dynamic content type based on file extension
Future<void> uploadProfileImage(
    {String? profileImagePath, String? userId}) async {
  if (profileImagePath == null || profileImagePath.isEmpty) {
    print("No image selected. Please select an image first.");
    return;
  }

  try {
    // Determine MIME type based on file extension
    final mimeType = lookupMimeType(profileImagePath);
    if (mimeType == null) {
      print("Unable to determine MIME type for the selected file.");
      return;
    }

    // Create a Multipart Request
    final url = Uri.parse('$commonUrl/upload');
    var request = http.MultipartRequest('POST', url);

    // Add image to the request with dynamic content type
    var file = await http.MultipartFile.fromPath(
      'image', // The key for the file in the backend
      profileImagePath,
      contentType: MediaType.parse(mimeType), // Dynamically set content type
    );
    request.files.add(file);

    // Add other fields (e.g., user_id)
    if (userId != null && userId.isNotEmpty) {
      request.fields['user_id'] = userId; // Dynamically pass the user_id
    } else {
      print("No user ID provided.");
    }

    // Send the request
    var response = await request.send();

    if (response.statusCode == 200) {
      print("Profile image uploaded successfully");

      // Optionally: Parse the response to get the uploaded file details if needed
      var responseData = await http.Response.fromStream(response);
      print('Response: ${responseData.body}');
    } else {
      // Log the response status code and body for further investigation
      print("Upload Failed: ${response.statusCode}");
      var responseData = await http.Response.fromStream(response);
      print('Response Body: ${responseData.body}');
    }
  } catch (e) {
    print("Error uploading image: $e");
  }
}

// Function to check if a username is available
Future<dynamic> checkUsername({required String username}) async {
  // Ensure the username is provided and not empty
  if (username.isEmpty) {
    return {"error": "Username must not be empty."};
  }

  final url = Uri.parse('$commonUrl/check-username');

  try {
    // Make POST request with username in the body
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"username": username}),
    );

    // Check for successful response
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse; // Return decoded JSON response
    } else {
      return {
        "error": "Failed to check username",
        "statusCode": response.statusCode,
        "body": response.body
      };
    }
  } catch (e) {
    return {"error": "Exception occurred", "details": e.toString()};
  }
}

Future<dynamic> SignupApi({
  required String username,
  required String email,
  String? phone,
  required String password,
  required String fullName, // Optional field
  required String dob,
  String? profileImagePath, // Optional field for profile image
  String? gender, // Optional field for gender
}) async {
  final url = Uri.parse('$commonUrl/signup');

  try {
    // Request location permission before fetching location
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // If location permission is denied, request permission
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return {
          "error": "Location permission is required for signup.",
        };
      }
    }

    // Get the user's location (latitude and longitude)
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Reverse geocode to get the country from latitude and longitude using geocoding package
    String? country;
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        country =
            placemarks.first.isoCountryCode; // ISO country code (e.g., 'US')
      }
    } catch (e) {
      print("Error during reverse geocoding: $e");
      country = "Unknown"; // Fallback to 'Unknown' if geocoding fails
    }

    // Get the user's timezone
    final timezone =
        DateTime.now().timeZoneName; // Fetch the current system timezone

    // Create a map for the request body
    Map<String, dynamic> requestData = {
      "username": username,
      "email": email,
      "password": password,
      "dob": dob,
      "full_name": fullName,
      "timezone": timezone,
      "country":
          country ?? "Unknown", // Fallback to 'Unknown' if no country found
    };

    // Add optional fields if they are provided
    if (phone != null && phone.isNotEmpty) {
      requestData["phone"] = phone;
    }
    if (gender != null && gender.isNotEmpty) {
      requestData["gender"] = gender;
    }

    // Handle profile image if provided (optional, not implemented in the example)
    // Uncomment and modify if you want to handle profile image
    // if (profileImagePath != null && profileImagePath.isNotEmpty) {
    //   final mimeType = lookupMimeType(profileImagePath);
    //   if (mimeType == null) {
    //     return {"error": "Invalid image type provided."};
    //   }
    //   final imageBytes = await http.MultipartFile.fromPath(
    //     'profileImage',
    //     profileImagePath,
    //     contentType: MediaType.parse(mimeType),
    //   );
    //   requestData["profileImage"] = base64Encode(await imageBytes.finalize().toList());
    // }

    // Make POST request with the user data
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestData),
    );

    // Parse the response
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse; // Return decoded JSON response
    } else {
      return {
        "error": "Signup failed",
        "statusCode": response.statusCode,
        "body": response.body,
      };
    }
  } catch (e) {
    return {
      "error": "Exception occurred during signup",
      "details": e.toString()
    };
  }
}

Future<bool> autoLogin() async {
  const storage = FlutterSecureStorage();
  final uniqueUserKey = await storage.read(key: 'user_token_pulseApp');

  if (uniqueUserKey != null) {
    return true; // No user key stored
  } else {
    return false;
  }
  // final url = Uri.parse('$commonUrl/auto-login');
  // final response = await http.post(
  //   url,
  //   headers: {
  //     'Content-Type': 'application/json',
  //   },
  //   body: jsonEncode({
  //     'unique_user_key': uniqueUserKey,
  //   }),
  // );

  // if (response.statusCode == 200) {
  //   // User authenticated
  //   final responseData = jsonDecode(response.body);
  //   return true;
  // } else {
  //   // Invalid or expired key
  //   await storage.delete(key: 'unique_user_key'); // Clear stored key
  //   return false;
  // }
}

Future<dynamic> fetchUserDetails() async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'user_token_pulseApp');
  if (token == null) {
    return {"error": "User token not found. Please log in again."};
  }

  final url = Uri.parse('$commonUrl/user-details');

  try {
    // Make a GET request with the token for authorization
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token, // Send token as Bearer token
      },
    );

    if (response.statusCode == 200) {
      // Parse and return the response body
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      // Return error response
      return {
        "error": "Failed to fetch user details",
        "statusCode": response.statusCode,
        "body": response.body,
      };
    }
  } catch (e) {
    return {"error": "Exception occurred", "details": e.toString()};
  }
}

// Function to send updated data to the backend API

Future<void> updateUserProfile(
    String userId, String fullName, String username, String bio) async {
  final url = Uri.parse('$commonUrl/user-updateprofile');

  // Create the request body
  final Map<String, String> updatedData = {
    'full_name': fullName,
    'username': username,
    'bio': bio,
  };

  // Send the PUT request to update the user profile
  try {
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': userId, // Send token as Bearer token
      },
      body: json.encode(updatedData),
    );

    if (response.statusCode == 200) {
      print('Profile updated successfully');
    } else {
      print('Failed to update profile: ${response.statusCode}');
    }
  } catch (e) {
    print('Error updating profile: $e');
  }
}

class AuthResult {
  final bool isSuccess;
  final String? message;
  final Map<String, dynamic>? data;

  AuthResult({required this.isSuccess, this.message, this.data});
}

Future<AuthResult> SigninApi(String emailOrPhone, String password) async {
  try {
    // Define the URL inside the static method
    final url = Uri.parse('$commonUrl/auth/signin');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "emailOrPhone": emailOrPhone,
        "password": password,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['user']['id'];
      await logout();
      await saveUserToken(token);
      return AuthResult(isSuccess: true, data: data);
    } else {
      final error = jsonDecode(response.body);
      return AuthResult(
        isSuccess: false,
        message: error['message'] ?? 'Unknown error',
      );
    }
  } catch (e) {
    return AuthResult(isSuccess: false, message: "Error: $e");
  }
}
