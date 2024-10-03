import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FacialRecord extends StatefulWidget {
  const FacialRecord({super.key});

  @override
  State<FacialRecord> createState() => _FacialRecordState();
}

class _FacialRecordState extends State<FacialRecord> {
  late CameraController _controller;
  // late Future<void> _initializeControllerFuture;
  // int _currentCameraIndex = 0;
  bool _isCapturing = false;
  // bool _showBackButton = true;
  bool isRun = false;
  final List<CameraDescription> cameras = Get.arguments ?? [];

  @override
  void initState() {
    super.initState();
    _initializeCameraController();
  }

  void _initializeCameraController() {
    _controller = CameraController(
      cameras[1],
      ResolutionPreset.high,
      enableAudio: false,
    );
    isRun = true;
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
        body: isRun
            ? FutureBuilder(
                future: _controller.initialize(),
                // future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CameraPreview(_controller);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }

  // --- Functions ---
  Future<void> captureAndSendImages() async {
    setState(() {
      _isCapturing = true;
      // _showBackButton = false;
    });

    while (_isCapturing) {
      try {
        // await _initializeControllerFuture;

        if (!mounted) return;

        final image = await _controller.takePicture();

        Uint8List bytes = await image.readAsBytes();
        String base64Image = base64Encode(bytes);

        final response = await sendImageToServer(base64Image);

        if (response == "Image limit reached") {
          if (mounted) {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("알림"),
                  content: const Text("얼굴 등록이 완료되었습니다."),
                  actions: [
                    TextButton(
                      child: const Text("확인"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
          setState(() {
            _isCapturing = false;
            // _showBackButton = true;
          });
          return;
        }

        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        setState(() {
          _isCapturing = false;
          // _showBackButton = true;
        });
      }
    }
  }

  Future<String> sendImageToServer(String base64Image) async {
    final url = Uri.parse('http://192.168.45.198:5000/upload');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'image': base64Image,
          // 'user_key': widget.userKey,
          // 'user_name': widget.userName,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody['message'];
      } else {
        return 'Failed';
      }
    } catch (e) {
      return 'Error';
    }
  }
} // End

