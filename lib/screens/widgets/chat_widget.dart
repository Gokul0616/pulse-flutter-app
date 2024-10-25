import 'package:flutter/material.dart';
import 'package:Pulse/screens/widgets/bottomNavbar/route_animations.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ScrollController _chatScrollController = ScrollController();
  final ScrollController _storyScrollController = ScrollController();
  Color _appBarColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _chatScrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    double scrollOffset = _chatScrollController.offset;
    setState(() {
      // Change the AppBar color based on the scroll position
      if (scrollOffset > 22) {
        _appBarColor = const Color.fromARGB(
            255, 255, 255, 255); // Change this color to your preference
      } else {
        _appBarColor = Colors.white; // Keep it white when at the top
      }
    });
  }

  @override
  void dispose() {
    _chatScrollController.removeListener(_scrollListener);
    _chatScrollController.dispose();
    _storyScrollController.dispose(); // Dispose of the story scroll controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _appBarColor, // AppBar color changes dynamically
        title: const Text(
          'Direct Messages',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {},
            color: Colors.black,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
            color: Colors.black,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Horizontal list for stories
          SizedBox(
            height: screenHeight * 0.085,
            child: ListView.builder(
              controller: _storyScrollController, // Use separate controller
              scrollDirection: Axis.horizontal,
              itemCount: userStories.length,
              itemBuilder: (context, index) {
                final story = userStories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: story['image'] != null
                            ? NetworkImage(story['image']!)
                            : const AssetImage(
                                    'assets/appImages/emptyProfile.jpg')
                                as ImageProvider,
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Text(story['name']!,
                          style: TextStyle(fontSize: screenHeight * 0.013)),
                    ],
                  ),
                );
              },
            ),
          ),

          // Divider between stories and chat list
          const Divider(thickness: 1),

          // Chat list
          Expanded(
            child: ListView.builder(
              controller: _chatScrollController, // Use chat scroll controller
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                final chat = chatList[index];
                return ListTile(
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: chat['image'] != null
                            ? NetworkImage(chat['image']!)
                            : const AssetImage(
                                    'assets/appImages/emptyProfile.jpg')
                                as ImageProvider,
                      ),
                      const Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 6,
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  title: Text(chat['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(chat['message']!),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(chat['time']!),
                      const SizedBox(height: 5),
                      if (chat['unread'] != '0')
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.blue,
                          child: Text(chat['unread']!,
                              style: TextStyle(
                                  fontSize: screenHeight * 0.012,
                                  color: Colors.white)),
                        ),
                    ],
                  ),
                  onTap: () {
                    navigateToChatScreen(context, chat['name']!,
                        chat['image'] ?? 'assets/appImages/emptyProfile.jpg');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Dummy data for user stories
final List<Map<String, String>> userStories = [
  {'name': 'Alice'},
  {
    'name': 'Bob',
    'image':
        'https://cdn.britannica.com/79/232779-050-6B0411D7/German-Shepherd-dog-Alsatian.jpg',
  },
  {
    'name': 'Charlie',
    'image':
        'https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg'
  },
  {
    'name': 'David',
    'image':
        'https://cdn.britannica.com/79/232779-050-6B0411D7/German-Shepherd-dog-Alsatian.jpg'
  },
  {
    'name': 'Eva',
    'image':
        'https://cdn.britannica.com/79/232779-050-6B0411D7/German-Shepherd-dog-Alsatian.jpg'
  },
];

// Dummy data for chat
final List<Map<String, String>> chatList = [
  {
    'name': 'Alice',
    'message': 'Hey, how are you?',
    'time': '9:30 AM',
    'unread': '2',
  },
  {
    'name': 'Bob',
    'message': 'Let\'s meet tomorrow',
    'time': '8:45 AM',
    'unread': '1',
    'image':
        'https://cdn.britannica.com/79/232779-050-6B0411D7/German-Shepherd-dog-Alsatian.jpg',
  },
  {
    'name': 'Charlie',
    'message': 'Got your email',
    'time': 'Yesterday',
    'unread': '3',
    'image':
        'https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg'
  },
  {
    'name': 'David',
    'message': 'See you soon!',
    'time': 'Monday',
    'unread': '0',
  },
  {
    'name': 'Eva',
    'message': 'Meeting at 4 PM?',
    'time': 'Sunday',
    'unread': '5',
    'image':
        'https://cdn.britannica.com/79/232779-050-6B0411D7/German-Shepherd-dog-Alsatian.jpg'
  },
  {
    'name': 'Frank',
    'message': 'Let\'s catch up later',
    'time': 'Saturday',
    'unread': '0',
    'image':
        'https://cdn.britannica.com/79/232779-050-6B0411D7/German-Shepherd-dog-Alsatian.jpg'
  },
  {
    'name': 'Grace',
    'message': 'Looking forward to it',
    'time': 'Friday',
    'unread': '4',
  },
  {
    'name': 'Hannah',
    'message': 'Call me when you\'re free',
    'time': 'Thursday',
    'unread': '0',
  },
  {
    'name': 'Isaac',
    'message': 'Great job!',
    'time': 'Wednesday',
    'unread': '1',
    'image':
        'https://rukminim2.flixcart.com/image/850/1000/kzsqykw0/poster/f/v/f/small-cute-dog-poster-multicolour-photo-paper-print-pomeranian-original-imagbqa4gddkyggd.jpeg?q=90&crop=false',
  },
  {
    'name': 'Jack',
    'message': 'See you at the event',
    'time': 'Tuesday',
    'unread': '0',
  },
];
