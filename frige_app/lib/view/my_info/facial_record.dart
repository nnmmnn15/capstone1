import 'dart:convert';
import 'dart:typed_data';
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
  late Future<void> _initializeControllerFuture;
  // int _currentCameraIndex = 0;
  bool _isCapturing = false;
  // bool _showBackButton = true;
  bool isRun = false;

  @override
  void initState() {
    super.initState();
    _initializeCameraController();
  }

  void _initializeCameraController() async {
    final cameras = await availableCameras();
    _controller =
        CameraController(cameras[0], ResolutionPreset.high, enableAudio: false)
          ..initialize();

    // _controller = CameraController(
    //   cameras[_currentCameraIndex],
    //   ResolutionPreset.high,
    //   enableAudio: false,
    // );

    _initializeControllerFuture = _controller.initialize();

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
      body: FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  // --- Functions ---
  Future<void> captureAndSendImages() async {
    setState(() {
      _isCapturing = true;
      // _showBackButton = false;
    });

    while (_isCapturing) {
      try {
        await _initializeControllerFuture;

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
                  title: Text("알림"),
                  content: Text("얼굴 등록이 완료되었습니다."),
                  actions: <Widget>[
                    TextButton(
                      child: Text("확인"),
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

        await Future.delayed(Duration(milliseconds: 500));
      } catch (e) {
        print(e);
        setState(() {
          _isCapturing = false;
          // _showBackButton = true;
        });
      }
    }
  }

  Future<String> sendImageToServer(String base64Image) async {
    final url = Uri.parse('http://172.20.10.5:5000/upload');
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
        print(responseBody['message']);
        return responseBody['message'];
      } else {
        print('Failed to upload image');
        return 'Failed';
      }
    } catch (e) {
      print('Error occurred while uploading image: $e');
      return 'Error';
    }
  }
} // End

