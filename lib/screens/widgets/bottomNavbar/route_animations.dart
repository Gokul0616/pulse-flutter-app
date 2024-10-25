import 'package:Pulse/screens/widgets/component/chat_screen_widget.dart';
import 'package:flutter/material.dart';

void navigateToChatScreen(
    BuildContext context, String userName, String userImage) {
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ChatScreen(userName: userName, userImage: userImage),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Start from right
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
}
