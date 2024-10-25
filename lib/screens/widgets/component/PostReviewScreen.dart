import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PostReviewScreen extends StatefulWidget {
  final File mediaFile;
  final String mediaType; // 'photo' or 'video'

  const PostReviewScreen({
    super.key,
    required this.mediaFile,
    required this.mediaType,
  });

  @override
  _PostReviewScreenState createState() => _PostReviewScreenState();
}

class _PostReviewScreenState extends State<PostReviewScreen> {
  final TextEditingController _captionController = TextEditingController();
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.mediaType == 'video') {
      _videoController = VideoPlayerController.file(widget.mediaFile)
        ..initialize().then((_) {
          setState(() {
            // Refresh the widget after the video is initialized
            print(
                'Video initialized: ${_videoController?.value.isInitialized}');
          });
        }).catchError((error) {
          print('Error initializing video: $error');
        });
    }
  }

  @override
  void dispose() {
    _videoController
        ?.dispose(); // Dispose of the video controller when no longer needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Post Review"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () {
              _submitPost();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.mediaType == 'photo'
                ? Image.file(widget.mediaFile, fit: BoxFit.cover)
                : _videoController?.value.isInitialized == true
                    ? Center(
                        child: Transform.rotate(
                          angle: 1.5708, // Rotate 90 degrees in radians
                          child: AspectRatio(
                            aspectRatio: 16 / 9, // Portrait aspect ratio
                            child: VideoPlayer(_videoController!),
                          ),
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _captionController,
              decoration: const InputDecoration(
                hintText: 'Add a caption...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ),
          if (widget.mediaType == 'video')
            VideoControls(controller: _videoController!),
        ],
      ),
    );
  }

  void _submitPost() {
    final caption = _captionController.text;

    // Handle post submission here
    Navigator.pop(context, {
      'media': widget.mediaFile,
      'caption': caption,
    });
  }
}

// Custom video controls
class VideoControls extends StatelessWidget {
  final VideoPlayerController controller;

  const VideoControls({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon:
              Icon(controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          onPressed: () {
            controller.pause();
            controller.seekTo(Duration.zero);
          },
        ),
      ],
    );
  }
}
