import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  final List<NotificationItem> notifications = [
    NotificationItem(
      userName: "Kizuna Kugisaki",
      action: "liked your post",
      timeAgo: "5m ago",
      userProfileUrl: "https://randomuser.me/api/portraits/women/1.jpg",
      postImageUrl: "https://picsum.photos/200/300?random=1",
    ),
    NotificationItem(
      userName: "Lelouch Lamperouge",
      action: "commented on your post",
      timeAgo: "15m ago",
      userProfileUrl: "https://randomuser.me/api/portraits/men/2.jpg",
      postImageUrl: "https://picsum.photos/200/300?random=2",
    ),
    NotificationItem(
      userName: "Saber",
      action: "shared your post",
      timeAgo: "30m ago",
      userProfileUrl: "https://randomuser.me/api/portraits/women/2.jpg",
      postImageUrl: "https://picsum.photos/200/300?random=3",
    ),
    NotificationItem(
      userName: "Shinji Ikari",
      action: "followed you",
      timeAgo: "1h ago",
      userProfileUrl: "https://randomuser.me/api/portraits/men/3.jpg",
      postImageUrl: "https://picsum.photos/200/300?random=4",
    ),
    NotificationItem(
      userName: "Asuka Langley",
      action: "liked your comment",
      timeAgo: "2h ago",
      userProfileUrl: "https://randomuser.me/api/portraits/women/3.jpg",
      postImageUrl: "https://picsum.photos/200/300?random=5",
    ),
    NotificationItem(
      userName: "Naruto Uzumaki",
      action: "tagged you in a post",
      timeAgo: "4h ago",
      userProfileUrl: "https://randomuser.me/api/portraits/men/4.jpg",
      postImageUrl: "https://picsum.photos/200/300?random=6",
    ),
    NotificationItem(
      userName: "Hinata Hyuga",
      action: "sent you a message",
      timeAgo: "6h ago",
      userProfileUrl: "https://randomuser.me/api/portraits/women/4.jpg",
      postImageUrl: "https://picsum.photos/200/300?random=7",
    ),
    NotificationItem(
      userName: "Goku",
      action: "invited you to a group",
      timeAgo: "8h ago",
      userProfileUrl: "https://randomuser.me/api/portraits/men/5.jpg",
      postImageUrl: "https://picsum.photos/200/300?random=8",
    ),
  ];

  NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              // Mark all as read functionality
            },
            child: const Text(
              'Mark Read',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return NotificationTile(notification: notification);
        },
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;

  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: Colors.white, // Add a light background color

      child: Row(
        children: [
          // User Avatar
          CircleAvatar(
            backgroundImage: NetworkImage(notification.userProfileUrl),
            radius: 24,
          ),
          const SizedBox(width: 12),
          // Notification Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        color: Colors.black), // Ensure text is visible
                    children: [
                      TextSpan(
                        text: notification.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue, // Use a color that stands out
                        ),
                      ),
                      TextSpan(
                        text: " ${notification.action}",
                        style: const TextStyle(
                            color: Colors.black), // Color for action
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.timeAgo,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Post Image Thumbnail
          if (notification.postImageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                notification.postImageUrl!,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(width: 8),
          // More Options Icon
          IconButton(
            icon: const Icon(Icons.more_horiz_outlined, color: Colors.grey),
            onPressed: () {
              // Show more options
            },
          ),
        ],
      ),
    );
  }
}

// Model for notification item
class NotificationItem {
  final String userName;
  final String action;
  final String timeAgo;
  final String userProfileUrl;
  final String? postImageUrl;

  NotificationItem({
    required this.userName,
    required this.action,
    required this.timeAgo,
    required this.userProfileUrl,
    this.postImageUrl,
  });
}
