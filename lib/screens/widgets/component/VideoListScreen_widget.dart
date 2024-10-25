import 'package:Pulse/screens/widgets/component/videoplayer_widget.dart';
import 'package:flutter/material.dart';

class VideoListScreen extends StatelessWidget {
  final List<VideoItem> videoItems;

  const VideoListScreen({super.key, required this.videoItems});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: videoItems.map((videoItem) {
        return GestureDetector(
          onTap: () {
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
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      videoItem.thumbnailUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  videoItem.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        videoItem.channelName,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      formatDuration(videoItem.duration),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 1.0), // Add divider
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String formatDuration(String duration) {
    int seconds = int.tryParse(duration) ?? 0; // Convert string to int
    int minutes = seconds ~/ 60; // Get minutes
    seconds = seconds % 60; // Get remaining seconds

    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}

// VideoItem model to hold video data
class VideoItem {
  final String url;
  final String thumbnailUrl;
  final String title;
  final String channelName;
  final String duration;

  VideoItem({
    required this.url,
    required this.thumbnailUrl,
    required this.title,
    required this.channelName,
    required this.duration,
  });
}
