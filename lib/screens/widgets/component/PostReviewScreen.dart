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
  double _rotationAngle = 0.0;
  bool _showAdditionalOptions = false; // Toggle for additional options
  String selectedPostIn = 'Post'; // Default value for photo posts
  @override
  void initState() {
    super.initState();
    if (widget.mediaType == 'video') {
      _videoController = VideoPlayerController.file(widget.mediaFile)
        ..initialize().then((_) {
          setState(() {
            final videoSize = _videoController!.value.size;
            if (videoSize.height < videoSize.width) {
              _rotationAngle = 0.0;
            } else {
              _rotationAngle = 90 * 3.14159 / 180;
            }
          });
        }).catchError((error) {
          print('Error initializing video: $error');
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set options based on media type (photo or video)
   
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Post Details",
          style: TextStyle(color: Colors.black),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.check, color: Colors.black),
        //     onPressed: () => _submitPost(),
        //   ),
        // ],
      ),
      body: SafeArea(
        child: widget.mediaType == 'photo'
            ? _buildPhotoPostDetails()
            : _buildVideoPostDetails(),
      ),
    );
  }

  // Photo Post Details
  Widget _buildPhotoPostDetails() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Thumbnail
          Container(
            color: Colors.white,
            child: Center(
              child: Image.file(
                widget.mediaFile,
                fit: BoxFit.contain,
                width: double.infinity,
                height: 300, // Fixed height for image preview
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Caption Field
                TextField(
                  controller: _captionController,
                  decoration: const InputDecoration(
                    hintText: 'Write a caption...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  maxLines: 5,
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 20),

                // Location, Tag People, Music
                _buildOptionRow(
                  icon: Icons.add_location,
                  title: 'Add location',
                  onPressed: () {
                    // Add location functionality
                  },
                ),
                const Divider(color: Colors.grey),
                _buildOptionRow(
                  icon: Icons.person_add,
                  title: 'Tag people',
                  onPressed: () {
                    // Add tag functionality
                  },
                ),
                const Divider(color: Colors.grey),
                _buildOptionRow(
                  icon: Icons.music_note,
                  title: 'Add music',
                  onPressed: () {
                    // Add music functionality
                  },
                ),
                const Divider(color: Colors.grey),

                // Visibility Dropdown
                _buildOptionRow(
                  icon: Icons.remove_red_eye,
                  title: 'Visibility',
                  trailingWidget: _buildDropdown(
                    options: ['Everyone', 'Only your followers', 'Private'],
                    onSelected: (value) {
                      // Handle visibility selection
                    },
                  ),
                ),
                const Divider(color: Colors.grey),
                   _buildOptionRow(
                  icon: Icons.remove_red_eye,
                  title: 'Post On',
                  trailingWidget: _buildDropdown(
                    options: ['Post', 'Tweak'],
                    onSelected: (value) {
                      // Handle visibility selection
                    },
                  ),
                ),
                const Divider(color: Colors.grey),
                const SizedBox(height: 20),

                // Additional Options (expandable)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showAdditionalOptions = !_showAdditionalOptions;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add more options',
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(
                        _showAdditionalOptions
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                      ),
                    ],
                  ),
                ),
                    const SizedBox(height: 20),
                if (_showAdditionalOptions) ...[
                  const SizedBox(height: 10),
                  _buildOptionRow(
                    icon: Icons.visibility_off,
                    title: 'Hide likes and comments',
                    onPressed: () {
                      // Handle hiding likes/comments
                    },
                  ),
                  const Divider(color: Colors.grey),
                  _buildOptionRow(
                    icon: Icons.share,
                    title: 'Disable sharing',
                    onPressed: () {
                      // Handle disabling sharing
                    },
                  ),
                  const Divider(color: Colors.grey),
                ],

                const SizedBox(height: 20),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: _submitPost,
                    style: ElevatedButton.styleFrom(
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.5, 40),
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Post',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPostDetails() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 100),

          // Video Player (ensure the video itself is aligned properly)
          if (_videoController != null && _videoController!.value.isInitialized)
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0), // Padding for video player
              child: AspectRatio(
                aspectRatio: 16 / 9, // Maintain the aspect ratio for the video
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationZ(
                      _rotationAngle), // Apply rotation if needed
                  child: VideoPlayer(_videoController!),
                ),
              ),
            ),
          const SizedBox(height: 100), // Space between video and options

          // Other options (like location, tag people, etc.)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Caption Field
                TextField(
                  controller: _captionController,
                  decoration: const InputDecoration(
                    hintText: 'Write a caption...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  maxLines: 5,
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 20),

                // Location, Tag People, Music
                _buildOptionRow(
                  icon: Icons.add_location,
                  title: 'Add location',
                  onPressed: () {
                    // Add location functionality
                  },
                ),
                const Divider(color: Colors.grey),
                _buildOptionRow(
                  icon: Icons.person_add,
                  title: 'Tag people',
                  onPressed: () {
                    // Add tag functionality
                  },
                ),
                const Divider(color: Colors.grey),
                _buildOptionRow(
                  icon: Icons.music_note,
                  title: 'Add music',
                  onPressed: () {
                    // Add music functionality
                  },
                ),
                const Divider(color: Colors.grey),

                // Visibility Dropdown
                _buildOptionRow(
                  icon: Icons.remove_red_eye,
                  title: 'Visibility',
                  trailingWidget: _buildDropdownVisibility(
                    options: ['Everyone', 'Only your followers', 'Private'],
                    onSelected: (value) {
                      // Handle visibility selection
                    },
                  ),
                ),
                const Divider(color: Colors.grey),
                _buildOptionRow(
                  icon: Icons.remove_red_eye,
                  title: 'Post On',
                  trailingWidget: _buildDropdownVisibility(
                    options: ['Post','Tweak','Video'],
                    onSelected: (value) {
                      // Handle visibility selection
                    },
                  ),
                ),
                const Divider(color: Colors.grey),
                const SizedBox(height: 20),

                // Additional Options (expandable)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showAdditionalOptions = !_showAdditionalOptions;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add more options',
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(
                        _showAdditionalOptions
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
       // Space between video and options
                if (_showAdditionalOptions) ...[
                  const SizedBox(height: 10),
                  _buildOptionRow(
                    icon: Icons.visibility_off,
                    title: 'Hide likes and comments',
                    onPressed: () {
                      // Handle hiding likes/comments
                    },
                  ),
                  const Divider(color: Colors.grey),
                  _buildOptionRow(
                    icon: Icons.share,
                    title: 'Disable sharing',
                    onPressed: () {
                      // Handle disabling sharing
                    },
                  ),
                  const Divider(color: Colors.grey),
                ],

                const SizedBox(height: 20),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: _submitPost,
                    style: ElevatedButton.styleFrom(
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.5, 40),
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Post',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Dropdown Widget for Visibility
  Widget _buildDropdown({
    required List<String> options,
    required Function(String) onSelected,
  }) {
    return DropdownButton<String>(
      dropdownColor: Colors.white,
      value:
          options[0], // Ensure this is not null and matches a valid value
      onChanged: (String? newValue) {
        setState(() {
          selectedPostIn = newValue!;
        });
      },
      items: options// Example of unique values
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
  
  Widget _buildDropdownVisibility({
    required List<String> options,
    required Function(String) onSelected,
  }) {
    return DropdownButton<String>(
      dropdownColor: Colors.white,
      value:
          options[0], // Ensure this is not null and matches a valid value
      onChanged: (String? newValue) {
        setState(() {
          selectedPostIn = newValue!;
        });
      },
      items: options // Example of unique values
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  // Option Row Widget
  Widget _buildOptionRow({
    required IconData icon,
    required String title,
    VoidCallback? onPressed,
    Widget? trailingWidget,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: trailingWidget ??
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: onPressed,
          ),
      onTap: onPressed,
    );
  }

  // Custom Video Controls (like play, pause, stop)
  Widget _buildVideoControls() {
    return Positioned(
      bottom: 100,
      right: 20,
      child: Column(
        children: [
          IconButton(
            icon: Icon(
              _videoController!.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              color: Colors.white,
              size: 36,
            ),
            onPressed: () {
              setState(() {
                if (_videoController!.value.isPlaying) {
                  _videoController!.pause();
                } else {
                  _videoController!.play();
                }
              });
            },
          ),
        ],
      ),
    );
  }

  // Submit Post Action
  void _submitPost() {
    final caption = _captionController.text.trim();
    print('Post Submitted with Caption: $caption');
  }
}
