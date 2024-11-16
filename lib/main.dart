import 'package:Pulse/api/apiComponent.dart';
import 'package:Pulse/screens/auth_screens.dart';
import 'package:Pulse/screens/signin_screen.dart';
import 'package:Pulse/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  @override
  void initState() {
    super.initState();
    // Add observer to track app lifecycle changes
    WidgetsBinding.instance.addObserver(this);
    _setImmersiveMode();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Reapply immersive mode when app comes back to foreground
    if (state == AppLifecycleState.resumed) {
      _setImmersiveMode();
    }
  }

  void _setImmersiveMode() {
    // Set immersive mode to hide system navigation and make status bar transparent
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make status bar fully transparent
      systemNavigationBarColor:
          Colors.transparent, // Make navigation bar transparent
      systemNavigationBarIconBrightness:
          Brightness.light, // Light icons for nav bar
      statusBarIconBrightness: Brightness.light, // Light icons for status bar
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/apiComponent',
      routes: {
        '/': (context) => const AuthScreen(),
        '/signup': (context) => const CreateAccountScreen(),
        '/signin': (context) => const SignInScreen(),
        '/Home' : (context) =>const HomeScreen(),

        // Add other routes if necessary
      },
    );
  }
}
