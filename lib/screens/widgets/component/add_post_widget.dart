import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart'; // For path provider
import "./PostReviewScreen.dart";

class AddPostWidget extends StatefulWidget {
  const AddPostWidget({super.key});

  @override
  _AddPostWidgetState createState() => _AddPostWidgetState();
}

class _AddPostWidgetState extends State<AddPostWidget> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  XFile? _mediaFile;
  bool _isRecording = false;
  bool _isFlashOn = false;
  final ResolutionPreset _currentResolution = ResolutionPreset.high;
  int selectedIndex = 1; // Default to the 15s option.
  final List<String> modes = ['60s', '15s', 'Templates'];
  final ImagePicker _imagePicker = ImagePicker();
  final ScrollController _scrollController = ScrollController();
  String? _lastImagePath; // Variable to hold the last image path

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _getLastImage(); // Fetch the last image on initialization
  }

  Future<void> _getLastImage() async {
    // Get the path to the gallery directory
    final directory = await getExternalStorageDirectory();
    final lastImagePath =
        '${directory!.path}/Pictures/'; // Assuming images are stored here

    // Fetch images from the gallery
    final List<FileSystemEntity> images = Directory(lastImagePath).listSync()
      ..retainWhere((entity) =>
          entity.path.endsWith('.jpg') || entity.path.endsWith('.png'));

    // If there are images, get the last one
    if (images.isNotEmpty) {
      // Sort by last modified date (newest first)
      images.sort(
          (a, b) => b.statSync().modified.compareTo(a.statSync().modified));
      setState(() {
        _lastImagePath = images.first.path; // Store the last image path
      });
    } else {
      setState(() {
        _lastImagePath = null; // No images available
      });
    }
  }

  Future<void> _openGallery() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _mediaFile = pickedFile; // Set the selected image
        _lastImagePath = pickedFile.path; // Update last image path
      });
      _goToReviewScreen(_mediaFile, 'photo'); // Navigate to review screen
    }
  }

  Future<void> _initializeCamera() async {
    await _requestPermissions();
    _cameras = await availableCameras();

    _controller = CameraController(
      _cameras!.first,
      _currentResolution,
    );
    await _controller!.initialize();
    setState(() {});
  }

  Future<void> _requestPermissions() async {
    if (!await Permission.camera.isGranted) {
      await Permission.camera.request();
    }
    if (!await Permission.storage.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller != null && _controller!.value.isInitialized) {
      _isFlashOn = !_isFlashOn;
      await _controller!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
      setState(() {});
    }
  }

  Future<void> _takePicture() async {
    if (_controller != null && _controller!.value.isInitialized) {
      final image = await _controller!.takePicture();
      setState(() {
        _mediaFile = image;
      });
      _goToReviewScreen(_mediaFile, 'photo');
    }
  }

  Future<void> _startVideoRecording() async {
    if (_controller != null &&
        _controller!.value.isInitialized &&
        !_isRecording) {
      await _controller!.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> _stopVideoRecording() async {
    if (_controller != null &&
        _controller!.value.isInitialized &&
        _isRecording) {
      final video = await _controller!.stopVideoRecording();
      setState(() {
        _mediaFile = video;
        _isRecording = false;
      });
      _goToReviewScreen(_mediaFile, 'video');
    }
  }

  void _goToReviewScreen(XFile? file, String mediaType) {
    if (file != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostReviewScreen(
            mediaFile: File(file.path),
            mediaType: mediaType,
          ),
        ),
      );
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras != null && _cameras!.length > 1) {
      await _controller?.dispose();

      final selectedCamera = _controller!.description == _cameras!.first
          ? _cameras!.last
          : _cameras!.first;

      _controller = CameraController(
        selectedCamera,
        _currentResolution,
      );

      try {
        await _controller!.initialize();
        setState(() {});
      } catch (e) {
        print("Error initializing camera: $e");
      }
    }
  }

  // Helper function to calculate the center index based on scroll offset.
  void _centerSelectedItem() {
    double offset = _scrollController.offset;
    double itemWidth =
        100; // Assuming each item has a width of 100px including padding.
    int index =
        (offset / itemWidth).round(); // Calculate the closest item index.
    setState(() {
      selectedIndex = index;
    });

    // Animate the scroll to center the selected item.
    _scrollController.animateTo(
      index * itemWidth,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          _controller == null || !_controller!.value.isInitialized
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                  height: screenHeight,
                  width: screenWidth,
                  child: CameraPreview(_controller!),
                ),
          Positioned(
            top: 40,
            right: 20,
            child: Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white), // X icon
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous screen
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
                  onPressed: _switchCamera,
                ),
                IconButton(
                  icon: const Icon(Icons.speed, color: Colors.white),
                  onPressed: () {
                    // Add speed functionality here
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.face_retouching_natural,
                      color: Colors.white),
                  onPressed: () {
                    // Add beauty filter functionality here
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.filter, color: Colors.white),
                  onPressed: () {
                    // Add filter functionality here
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.timer, color: Colors.white),
                  onPressed: () {
                    // Add timer functionality here
                  },
                ),
                IconButton(
                  icon: Icon(
                    _isFlashOn ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                  ),
                  onPressed: _toggleFlash,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.face, color: Colors.white),
                      onPressed: () {
                        // Add effects functionality
                      },
                    ),
                    GestureDetector(
                      onLongPress: _startVideoRecording,
                      onLongPressEnd: (details) => _stopVideoRecording(),
                      onTap: _takePicture,
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _openGallery, // Open gallery functionality
                      child: _lastImagePath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(_lastImagePath!),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.black, // Black box if no image
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                    ),
                  ],
                ),
                // Horizontal scrollable timer options (60s, 15s, Templates)
        Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: 50,
                    child: NotificationListener<ScrollEndNotification>(
                      onNotification: (scrollEnd) {
                        _centerSelectedItem();
                        return true;
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount:  modes.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                              _centerSelectedItem(); // Ensure selected item is centered
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: (screenWidth / 2 - 40) / 5,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    modes[index],
                                    style: TextStyle(
                                      color: selectedIndex == index
                                          ? Colors.white
                                          : Colors.white54,
                                      fontWeight: selectedIndex == index
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  if (selectedIndex == index)
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
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
}
