import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String userImage;

  const ChatScreen({
    super.key,
    required this.userName,
    required this.userImage,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> messages = [];
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        messages.add({
          'text': _messageController.text,
          'sender': 'me',
          'time': DateTime.now().toString(),
        });
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.userImage),
              radius: screenHeight * 0.025,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: TextStyle(
                      color: Colors.black, fontSize: screenHeight * 0.025),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                      color: Colors.green, fontSize: screenHeight * 0.015),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          Icon(Icons.video_call, color: Colors.black),
          SizedBox(width: 10),
          Icon(Icons.call, color: Colors.black),
          SizedBox(width: 10),
          Icon(Icons.more_vert, color: Colors.black),
          SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: screenHeight * 0.1,
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                bool isMe = message['sender'] == 'me';

                return Container(
                  margin: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.005,
                      horizontal: screenHeight * 0.02),
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(screenHeight * 0.015),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[200] : Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(screenHeight * 0.02),
                            topRight: Radius.circular(screenHeight * 0.02),
                            bottomLeft: isMe
                                ? Radius.circular(screenHeight * 0.02)
                                : Radius.zero,
                            bottomRight: isMe
                                ? Radius.zero
                                : Radius.circular(screenHeight * 0.02),
                          ),
                        ),
                        child: Text(
                          message['text']!,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: screenHeight * 0.018),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        message['time']!.substring(11, 16),
                        style: TextStyle(
                            color: Colors.grey, fontSize: screenHeight * 0.015),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.01),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.black),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions, color: Colors.black),
                    onPressed: () {},
                  ),
                  // TextField wrapped in Container for fixed height
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenHeight * 0.02),
                    width: screenWidth * 0.52, // Adjust width as needed
                    height:
                        screenHeight * 0.05, // Fixed height for the text field
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type your message here!',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      maxLines: 1, // Set maxLines to 1 for single line input
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.mic, color: Colors.black),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: _sendMessage,
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
