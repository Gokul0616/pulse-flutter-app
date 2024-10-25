import 'package:flutter/material.dart';

class AlertMessage extends StatelessWidget {
  final String heading;
  final String message;
  final VoidCallback? triggerFunction;
  final bool showAlert;
  final Function(bool) setShowAlert;
  final bool isRight;
  final String rightButtonText;

  const AlertMessage({
    super.key,
    required this.heading,
    required this.message,
    required this.setShowAlert,
    required this.showAlert,
    this.triggerFunction,
    this.isRight = false,
    this.rightButtonText = "OK",
  });

  @override
  Widget build(BuildContext context) {
    if (!showAlert) return const SizedBox.shrink();

    return Stack(
      children: [
        // Dark background overlay
        Container(
          color: Colors.black.withOpacity(0.5),
          width: double.infinity,
          height: double.infinity,
        ),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Heading
                Text(
                  heading,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Roboto-Medium',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                // Message
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: 'Roboto-Medium',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Divider(color: Color(0xFFDDDDDD)),
                Row(
                  children: [
                    if (isRight)
                      Expanded(
                        child: InkWell(
                          onTap: triggerFunction,
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Color(0xFFDDDDDD)),
                              ),
                            ),
                            child: Text(
                              rightButtonText,
                              style: const TextStyle(
                                color: Color(0xFF007AFF),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto-Medium',
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Cancel button
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setShowAlert(false); // Close the alert
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF007AFF),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto-Medium',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
