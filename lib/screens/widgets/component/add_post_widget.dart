import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart'; // For path provider
import "./PostReviewScreen.dart";
import 'dart:async'; 

class AddPostWidget extends StatefulWidget {
  const AddPostWidget({super.key});

  @override
  _AddPostWidgetState createState() => _AddPostWidgetState();
}

class _AddPostWidgetState extends State<AddPostWidget>
    with TickerProviderStateMixin {
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
  late Timer _videoTimer;
  int _videoDuration = 0; // Duration in seconds
  String? _lastImagePath; // Variable to hold the last image path

  // Animation controller for the shutter button effect
  late AnimationController _shutterController;
  late Animation<double> _shutterAnimation;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _getLastImage(); // Fetch the last image on initialization

    // Initialize the shutter effect animation
    _shutterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _shutterAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(parent: _shutterController, curve: Curves.easeInOut),
    );
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
    // Avoid reinitializing if already initialized
    if (_controller == null || !_controller!.value.isInitialized) {
      await _requestPermissions();
      _cameras = await availableCameras();

      _controller = CameraController(
        _cameras!.first,
        _currentResolution,
      );
      await _controller!.initialize();
      setState(() {});
    }
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
      // Trigger the shutter animation when the picture is taken
      _shutterController.forward().then((_) {
        _shutterController.reverse();
      });

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
      // Trigger the shutter animation when recording starts
      _shutterController.forward().then((_) {
        _shutterController.reverse();
      });

      await _controller!.startVideoRecording();
      setState(() {
        _isRecording = true;
        _videoDuration = 0; // Reset the timer
      });

      // Start a timer that updates every second
      _videoTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_videoDuration < 30) {
            _videoDuration++;
          } else {
            // Stop recording after 30 seconds
            _stopVideoRecording();
          }
        });
      });
    }
  }
// Stop video recording and cancel the timer
  Future<void> _stopVideoRecording() async {
    if (_controller != null &&
        _controller!.value.isInitialized &&
        _isRecording) {
      final video = await _controller!.stopVideoRecording();
      setState(() {
        _mediaFile = video;
        _isRecording = false;
        _videoDuration = 0; // Reset the timer when done
      });
      _videoTimer.cancel(); // Stop the timer
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
  void dispose() {
    // Properly dispose the camera when the widget is disposed
    _controller!.dispose();
    _shutterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      // Wrap your Scaffold in SafeArea to avoid UI overlaps
      child: Scaffold(
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
                    icon:
                        const Icon(Icons.close, color: Colors.white), // X icon
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous screen
                    },
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.flip_camera_ios, color: Colors.white),
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
              bottom: 30,
              left: screenWidth / 2 - 40,
              child: GestureDetector(
                onLongPress:
                    _startVideoRecording, // Start recording on long press
                onLongPressEnd: (details) {
                  _stopVideoRecording(); // Stop recording when long press ends
                },
                onTap: () {
                  // On tap, take a picture
                  _takePicture();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Circular progress indicator
                    if (_isRecording)
                      CircularProgressIndicator(
                        value: _videoDuration / 30, // Track progress (0-1)
                        strokeWidth: 4,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                        backgroundColor: Colors.transparent,
                      ),
                    // Shutter button
                    ScaleTransition(
                      scale: _shutterAnimation,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          // border: Border.all(color: Colors.black, width: 4),
                        ),
                        width: 80,
                        height: 80,
                        child: Icon(
                          _isRecording
                              ? Icons.stop
                              : Icons.camera_alt, // Show stop or camera icon
                          color: _isRecording
                              ? Colors.red
                              : Colors.black, // Change color for recording
                          size: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )


          ],
        ),
      ),
    );
  }
}
