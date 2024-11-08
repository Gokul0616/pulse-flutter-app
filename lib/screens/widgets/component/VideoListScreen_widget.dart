import 'package:Pulse/screens/widgets/component/videoplayer_widget.dart';
import 'package:flutter/material.dart';

class VideoListScreen extends StatelessWidget {
  final List<VideoItem> videoItems;
  final Function(VideoItem) onVideoClicked;

  const VideoListScreen({
    super.key,
    required this.videoItems,
    required this.onVideoClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: videoItems.map((videoItem) {
        return GestureDetector(
          onTap: () {
            onVideoClicked(videoItem);
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    VideoPlayerScreen(videoUrl: videoItem.url),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0); // Bottom to top
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                reverseTransitionDuration: const Duration(milliseconds: 300),
              ),
            );
          },
          child: Container(
            margin:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // User info section
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  color: Colors
                      .grey[100], // Lighter background to match with title
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(videoItem.userProfileUrl),
                        radius: 16,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            videoItem.userName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '@${videoItem.userHandle}',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Video Thumbnail
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12.0),
                        ),
                        child: Image.network(
                          videoItem.thumbnailUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ],
                ),
                // Video Title and details
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        videoItem.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Title text color
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${videoItem.uploadTime} • ${videoItem.viewCount} views',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String formatDuration(String duration) {
    int seconds = int.tryParse(duration) ?? 0;
    int minutes = seconds ~/ 60;
    seconds = seconds % 60;

    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}

// VideoItem model to hold video data
class VideoItem {
  final String url;
  final String thumbnailUrl;
  final String title;
  final String userProfileUrl;
  final String userName;
  final String userHandle;
  final String uploadTime;
  final String viewCount;
  final String duration;

  VideoItem({
    required this.url,
    required this.thumbnailUrl,
    required this.title,
    required this.userProfileUrl,
    required this.userName,
    required this.userHandle,
    required this.uploadTime,
    required this.viewCount,
    required this.duration,
  });
}
