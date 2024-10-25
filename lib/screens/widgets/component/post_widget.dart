import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final String userName;
  final String postTime;
  final String userProfileUrl;
  final String postUrl;
  final bool isLiked;
  final Function onLikeToggle;
  final Function onCommentPressed;

  const PostWidget({
    super.key,
    required this.userName,
    required this.postTime,
    required this.userProfileUrl,
    required this.postUrl,
    required this.isLiked,
    required this.onLikeToggle,
    required this.onCommentPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        onLikeToggle();
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(userProfileUrl),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(postTime, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Post Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                postUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300,
              ),
            ),
            // Post Actions
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.pink : null,
                        ),
                        onPressed: () {
                          onLikeToggle();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.comment_outlined),
                        onPressed: () {
                          onCommentPressed();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {
                          // Handle share action
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark_border),
                        onPressed: () {
                          // Handle save action
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Likes and comments count
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "123 likes", // This can be modified to accept a like count
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
