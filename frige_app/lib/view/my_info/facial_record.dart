import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FacialRecord extends StatefulWidget {
  const FacialRecord({super.key});

  @override
  State<FacialRecord> createState() => _FacialRecordState();
}

class _FacialRecordState extends State<FacialRecord> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  int _currentCameraIndex = 0;
  bool _isCapturing = false;
  bool _showBackButton = true;
  bool isRun = false;

  @override
  void initState() {
    super.initState();
    // _initializeCameraController();
  }

  void _initializeCameraController() async {
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras[_currentCameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _isCapturing = false;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('얼굴등록'),
      ),
    );
  }
}
