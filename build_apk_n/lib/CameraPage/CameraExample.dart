// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:http/http.dart' as http;

// // class CameraExample extends StatefulWidget {
// //   const CameraExample({Key? key}) : super(key: key);

// //   @override
// //   _CameraExampleState createState() => _CameraExampleState();
// // }

// // class _CameraExampleState extends State<CameraExample> {
// //   File? _image;
// //   final ImagePicker _picker = ImagePicker();

// //   Future<void> getImage() async {
// //     try {
// //       // 카메라를 열어 사용자가 사진을 찍도록 함
// //       final XFile? image = await _picker.pickImage(source: ImageSource.camera);
// //       if (image == null) return;

// //       setState(() {
// //         // 촬영된 사진의 경로를 _image 변수에 저장
// //         _image = File(image.path);
// //       });

// //       // 촬영된 사진을 서버에 업로드
// //       uploadImage(_image!);
// //     } catch (e) {
// //       print('Error picking image: $e');
// //     }
// //   }

// //   Future<void> uploadImage(File imageFile) async {
// //     try {
// //       var request = http.MultipartRequest(
// //         'POST',
// //         //Uri.parse('http://192.168.0.19:5000/upload'),
// //         Uri.parse('http://172.20.10.5:5000/upload'),
// //       );
// //       request.files.add(
// //         await http.MultipartFile.fromPath(
// //           'image',
// //           imageFile.path,
// //         ),
// //       );
// //       var response = await request.send();

// //       if (response.statusCode == 200) {
// //         print('Image uploaded successfully');
// //       } else {
// //         print('Failed to upload image');
// //       }
// //     } catch (e) {
// //       print('Error uploading image: $e');
// //     }
// //   }

// //   Widget showImage() {
// //     return Container(
// //       color: const Color(0xffd0cece),
// //       width: MediaQuery.of(context).size.width,
// //       height: MediaQuery.of(context).size.width,
// //       child: Center(
// //         child: _image == null
// //             ? const Text('No image selected.')
// //             : Image.file(_image!),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     SystemChrome.setPreferredOrientations(
// //         [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

// //     return Scaffold(
// //       backgroundColor: const Color(0xfff4f3f9),
// //       body: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           const SizedBox(height: 25.0),
// //           showImage(),
// //           const SizedBox(height: 50.0),
// //           FloatingActionButton(
// //             child: const Icon(Icons.add_a_photo),
// //             tooltip: 'Capture Image',
// //             onPressed: getImage,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'take_picture_screen.dart'; // `TakePictureScreen` 파일 경로에 맞게 수정

// class CameraExample extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             final cameras = await availableCameras();
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => TakePictureScreen(cameras: cameras),
//               ),
//             );
//           },
//           child: Text('Open Camera'),
//         ),
//       ),
//     );
//   }
// }
