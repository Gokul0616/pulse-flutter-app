// import 'package:Pulse/screens/auth_screens.dart';
// import 'package:Pulse/screens/signin_screen.dart';
// import 'package:Pulse/screens/signup_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'screens/home_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _setImmersiveMode();
//     // Check login status
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       _setImmersiveMode();
//     }
//   }

//   void _setImmersiveMode() {
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       systemNavigationBarColor: Colors.transparent,
//       systemNavigationBarIconBrightness: Brightness.light,
//       statusBarIconBrightness: Brightness.light,
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Update initialRoute based on login status

//     return MaterialApp(
//       title: 'Flutter Auth Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       initialRoute: '/Home',
//       routes: {
//         '/': (context) => const AuthScreen(),
//         '/signup': (context) => const CreateAccountScreen(),
//         '/signin': (context) => const SignInScreen(),
//         '/Home': (context) => const HomeScreen(),
//       },
//     );
//   }
// }


import 'package:Pulse/api/apiComponent.dart';
import 'package:Pulse/screens/auth_screens.dart';
import 'package:Pulse/screens/signin_screen.dart';
import 'package:Pulse/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Future<bool>? _loginStatusFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // _setImmersiveMode();
    // Initialize the login status check
    _loginStatusFuture = _checkLoginStatus();
  }

  Future<bool> _checkLoginStatus() async {
    try {
      return await autoLogin(); // Async check for login status
    } catch (e) {
      return false; // If any error occurs, consider user as not logged in
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     _setImmersiveMode();
  //   }
  // }

  // void _setImmersiveMode() {
  //   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent,
  //     systemNavigationBarColor: Colors.transparent,
  //     systemNavigationBarIconBrightness: Brightness.light,
  //     statusBarIconBrightness: Brightness.light,
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Use a FutureBuilder to wait for the login status
      home: FutureBuilder<bool>(
        future: _loginStatusFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading spinner while the login status is being checked
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError ||
              !snapshot.hasData ||
              !snapshot.data!) {
            // If there was an error or the user is not logged in, show the auth screens
            return const AuthScreen();
          } else {
            // If the user is logged in, show the home screen
            return const HomeScreen();
          }
        },
      ),
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/signup': (context) => const CreateAccountScreen(),
        '/signin': (context) => const SignInScreen(),
        '/Home': (context) => const HomeScreen(),
      },
    );
  }
}
