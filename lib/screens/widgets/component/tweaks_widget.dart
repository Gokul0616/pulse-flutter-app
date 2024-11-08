import 'package:flutter/material.dart';

class TweakWidget extends StatelessWidget {
  final String userName;
  final String handle;
  final String timeAgo;
  final String userProfileUrl;
  final String tweakContent;
  final String? tweakImageUrl;
  final bool isLiked;
  final int likeCount;
  final int commentCount;
  final int retweakCount;
  final VoidCallback onLikeToggle;
  final VoidCallback onCommentPressed;
  final VoidCallback onRetweakPressed;
  final VoidCallback onSharePressed;

  const TweakWidget({
    super.key,
    required this.userName,
    required this.handle,
    required this.timeAgo,
    required this.userProfileUrl,
    required this.tweakContent,
    this.tweakImageUrl,
    required this.isLiked,
    required this.likeCount,
    required this.commentCount,
    required this.retweakCount,
    required this.onLikeToggle,
    required this.onCommentPressed,
    required this.onRetweakPressed,
    required this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the TweakDetailPage with a left-to-right slide animation
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                TweakDetailPage(
              userName: userName,
              handle: handle,
              timeAgo: timeAgo,
              userProfileUrl: userProfileUrl,
              tweakContent: tweakContent,
              tweakImageUrl: tweakImageUrl,
              isLiked: isLiked,
              likeCount: likeCount,
              commentCount: commentCount,
              retweakCount: retweakCount,
              onLikeToggle: onLikeToggle,
              onCommentPressed: onCommentPressed,
              onRetweakPressed: onRetweakPressed,
              onSharePressed: onSharePressed,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              // Define the slide transition from left to right
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(userProfileUrl),
              radius: 25,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '@$handle · $timeAgo',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(tweakContent),
                  const SizedBox(height: 10),
                  if (tweakImageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        tweakImageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _TweakActionButton(
                          icon: Icons.chat_bubble_outline,
                          label: commentCount.toString(),
                          onPressed: onCommentPressed,
                        ),
                        _TweakActionButton(
                          icon: Icons.repeat,
                          label: retweakCount.toString(),
                          onPressed: onRetweakPressed,
                        ),
                        _TweakActionButton(
                          icon:
                              isLiked ? Icons.favorite : Icons.favorite_border,
                          label: likeCount.toString(),
                          onPressed: onLikeToggle,
                          iconColor: isLiked ? Colors.red : Colors.grey,
                        ),
                        _TweakActionButton(
                          icon: Icons.share_outlined,
                          label: '',
                          onPressed: onSharePressed,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// _TweakActionButton and TweakDetailPage remain the same

class _TweakActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? iconColor;

  const _TweakActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor ?? Colors.grey),
          if (label.isNotEmpty) const SizedBox(width: 4),
          if (label.isNotEmpty)
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
        ],
      ),
    );
  }
}

class TweakDetailPage extends StatelessWidget {
  final String userName;
  final String handle;
  final String timeAgo;
  final String userProfileUrl;
  final String tweakContent;
  final String? tweakImageUrl;
  final bool isLiked;
  final int likeCount;
  final int commentCount;
  final int retweakCount;
  final VoidCallback onLikeToggle;
  final VoidCallback onCommentPressed;
  final VoidCallback onRetweakPressed;
  final VoidCallback onSharePressed;

  const TweakDetailPage({
    super.key,
    required this.userName,
    required this.handle,
    required this.timeAgo,
    required this.userProfileUrl,
    required this.tweakContent,
    this.tweakImageUrl,
    required this.isLiked,
    required this.likeCount,
    required this.commentCount,
    required this.retweakCount,
    required this.onLikeToggle,
    required this.onCommentPressed,
    required this.onRetweakPressed,
    required this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Tweak"),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(userProfileUrl),
                  radius: 25,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '@$handle · $timeAgo',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(tweakContent),
            if (tweakImageUrl != null) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  tweakImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _TweakActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: commentCount.toString(),
                  onPressed: onCommentPressed,
                ),
                _TweakActionButton(
                  icon: Icons.repeat,
                  label: retweakCount.toString(),
                  onPressed: onRetweakPressed,
                ),
                _TweakActionButton(
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  label: likeCount.toString(),
                  onPressed: onLikeToggle,
                  iconColor: isLiked ? Colors.red : Colors.grey,
                ),
                _TweakActionButton(
                  icon: Icons.share_outlined,
                  label: '',
                  onPressed: onSharePressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
