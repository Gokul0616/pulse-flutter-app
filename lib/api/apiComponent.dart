import 'package:http/http.dart' as http;

final commonUrl = 'http://10.0.2.2:5000/api';
// Function to call the backend API
Future<void> testWelcomeApi() async {
  final url = Uri.parse(commonUrl + '/welcome');
// Update with your server URL
  try {
    final response = await http.post(url);
    if (response.statusCode == 200) {
      print("Welcome message logged on server!");
    } else {
      print("Failed to reach the server: ${response.statusCode}");
    }
  } catch (e) {
    print("Error: $e");
  }
}

Future<void> SignupApi() async {
  final url = Uri.parse(commonUrl + '/signup');
// Update with your server URL
  try {
    final response = await http.post(url);
    if (response.statusCode == 200) {
      print("Welcome message logged on server!");
    } else {
      print("Failed to reach the server: ${response.statusCode}");
    }
  } catch (e) {
    print("Error: $e");
  }
}
