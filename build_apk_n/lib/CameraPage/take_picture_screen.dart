import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TakePictureScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String userKey;
  final String userName;
  const TakePictureScreen({Key? key, required this.cameras, required this.userKey, required this.userName}) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  int _currentCameraIndex = 0;
  bool _isCapturing = false;
  bool _showBackButton = true;

  @override
  void initState() {
    super.initState();
    _initializeCameraController();
  }

  void _initializeCameraController() {
    _controller = CameraController(
      widget.cameras[_currentCameraIndex],
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

  Future<void> captureAndSendImages() async {
    setState(() {
      _isCapturing = true;
      _showBackButton = false;
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
          if(mounted){
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
            _showBackButton = true;
          });
          return;
        }

        await Future.delayed(Duration(milliseconds: 500));
      } catch (e) {
        print(e);
        setState(() {
          _isCapturing = false;
          _showBackButton = true;
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
          'user_key': widget.userKey,
          'user_name': widget.userName,
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

  void _switchCamera() {
    if (widget.cameras.length > 1) {
      _currentCameraIndex = (_currentCameraIndex + 1) % widget.cameras.length;
      _initializeCameraController();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _showBackButton,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Take Picture'),
          automaticallyImplyLeading: _showBackButton,
          actions: [
            IconButton(
              icon: Icon(Icons.switch_camera),
              onPressed: _switchCamera,
            ),
          ],
        ),
        body: Stack(
          children: [
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            if (_isCapturing)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 50),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '잠시만 기다려주세요',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        floatingActionButton: _isCapturing
            ? null
            : FloatingActionButton(
                onPressed: captureAndSendImages,
                child: Icon(Icons.camera_alt),
              ),
      ),
    );
  }
}
