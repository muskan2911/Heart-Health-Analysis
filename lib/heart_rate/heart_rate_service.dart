import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class HeartRateMonitorPage extends StatefulWidget {
  const HeartRateMonitorPage({super.key});

  @override
  _HeartRateMonitorPageState createState() => _HeartRateMonitorPageState();
}

class _HeartRateMonitorPageState extends State<HeartRateMonitorPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  final List<double> _bpmData = [];
  double _currentBpm = 0;
  bool _isMonitoring = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      _controller = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller!.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _startMonitoring() async {
    setState(() {
      _isMonitoring = true;
    });

    while (_isMonitoring) {
      await _initializeControllerFuture;
      if (_controller != null && _controller!.value.isInitialized) {
        final image = await _controller!.takePicture();
        await _processImage(File(image.path));
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  Future<void> _processImage(File imageFile) async {
    img.Image? image = img.decodeImage(await imageFile.readAsBytes());

    if (image != null) {
      double bpm = _calculateHeartRate(image);
      setState(() {
        _currentBpm = bpm;
        _bpmData.add(bpm);
      });
    }
  }

  double _calculateHeartRate(img.Image image) {
    // Simplified placeholder implementation
    List<double> pixelIntensities = [];
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        img.Pixel pixel = image.getPixel(x, y);
        double intensity = (pixel.r + pixel.g + pixel.b) / 3.0;
        pixelIntensities.add(intensity);
      }
    }
    double meanIntensity =
        pixelIntensities.reduce((a, b) => a + b) / pixelIntensities.length;
    double frequency = (meanIntensity / 255) * 2.0;
    return frequency * 60;
  }

  Future<void> _stopMonitoring() async {
    setState(() {
      _isMonitoring = false;
    });
  }

  Future<void> _flipCamera() async {
    if (_controller != null) {
      final cameras = await availableCameras();
      final currentCameraIndex = cameras.indexOf(_controller!.description);
      final nextCameraIndex = (currentCameraIndex + 1) % cameras.length;

      await _controller!.dispose();
      _controller = CameraController(
        cameras[nextCameraIndex],
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller!.initialize();
      setState(() {});
    }
  }

  void _viewReport() async {
    // Calculate average BPM
    double averageBpm = _bpmData.isNotEmpty
        ? _bpmData.reduce((a, b) => a + b) / _bpmData.length
        : 0;

    // Show the report dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Heart Rate Report'),
          content: Text(
            'Your average BPM: ${averageBpm.toStringAsFixed(1)}',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                // Save to Firestore
                User? user = FirebaseAuth.instance.currentUser;

                if (user != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .collection('Heart Rate')
                      .add({
                    'average_bpm': averageBpm,
                    'timestamp': FieldValue.serverTimestamp(),
                  }).then((_) {
                    print('Average BPM saved to Firestore');
                  }).catchError((error) {
                    print("Error saving BPM: $error");
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heart Rate Monitor',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurple, width: 3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(17),
                      child: _controller != null &&
                              _controller!.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: 1,
                              child: CameraPreview(_controller!),
                            )
                          : const Center(child: Text('Camera not available')),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Current BPM',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    _currentBpm.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _controller != null &&
                                _controller!.value.isInitialized
                            ? (_isMonitoring
                                ? _stopMonitoring
                                : _startMonitoring)
                            : null,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              _isMonitoring ? Colors.red : Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(_isMonitoring ? 'Stop' : 'Start'),
                      ),
                      ElevatedButton(
                        onPressed: _controller != null &&
                                _controller!.value.isInitialized
                            ? _flipCamera
                            : null,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.all(15),
                          shape: const CircleBorder(),
                        ),
                        child: Icon(Icons.flip_camera_ios),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _viewReport,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('View and Save Report'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
