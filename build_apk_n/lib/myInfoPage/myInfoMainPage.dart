import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:build_apk_n/myInfoPage/member_modify_page.dart'; // 회원정보 수정 페이지 임포트
import 'package:build_apk_n/myInfoPage/DeleteMember_page.dart'; // 회원탈퇴 페이지 임포트
import 'package:build_apk_n/loginPage/loginMainPage.dart'; // 로그인 페이지 임포트
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:build_apk_n/CameraPage/take_picture_screen.dart';

class MyInfoPage extends StatefulWidget {
  final String userName; // 사용자 이름 필드 추가

  const MyInfoPage({Key? key, required this.userName}) : super(key: key);

  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  late Map<String, dynamic> userData;

  @override
  void initState() {
    super.initState();
    fetchUserData(); // 유저 데이터 가져오기
  }

  // userId로 User의 db를 가져오는 함수
  // 사용방법 userData['user_key'] / user_key 는 db의 칼럼명
  void fetchUserData() async {
    //var url = Uri.parse('http://127.0.0.1:5000/get_user2');
    //var url = Uri.parse('http://192.168.0.19:5000/get_user2');
    var url = Uri.parse('http://172.20.10.5:5000/get_user2');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userName = widget.userName; // prefs.getString('userId') ?? '';
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'name': userName}));

      if (response.statusCode == 200) {
        setState(() {
          userData = jsonDecode(response.body);
        });
      } else {
        print('Failed to load user data');
      }
    } catch (e) {
      print('Error occurred while fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('마이페이지'), // 앱바에 타이틀 추가
            SizedBox(width: 8), // 간격 조정
          ],
        ),
      ),
      body: Column(
        children: [
          // "마이페이지" 아래에 선 추가
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey.shade300,
          ),
          // 사용자 이름 추가
          SizedBox(height: 20), // 공간 추가
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Icon(
                //   Icons.account_circle,
                //   size: 28,
                //   color: Colors.black,
                // ),
                SizedBox(width: 8),
                Text(
                  '${widget.userName}님 안녕하세요!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // 회원정보 수정 카드
          GestureDetector(
            onTap: () {
              // 회원정보 수정 페이지로 이동
              // user_id 정보 전송
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MemberModifyPage(userId: userData['user_id'])),
              );
            },
            child: Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 16),
                  Text(
                    '회원정보 수정',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          // 얼굴 등록
          GestureDetector(
            onTap: () async{
              final cameras = await availableCameras();
              // 회원정보 수정 페이지로 이동
              // user_id 정보 전송
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TakePictureScreen(cameras: cameras,userKey: userData['user_key'].toString(), userName: userData['user_name'])),
              );
            },
            child: Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.face_retouching_natural),
                  SizedBox(width: 16),
                  Text(
                    '얼굴 등록',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          // 회원탈퇴 카드
          GestureDetector(
            onTap: () {
              // 회원탈퇴 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WithdrawPage(
                        userId: userData['user_id'],
                        userPw: userData['user_pw'])),
              );
            },
            child: Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.exit_to_app),
                  SizedBox(width: 16),
                  Text(
                    '회원탈퇴',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          // 로그아웃 카드
          GestureDetector(
            onTap: () {
              showCupertinoModalPopup<void>(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: Text('${widget.userName}님, 로그아웃하시겠습니까?'),
                  actions: <CupertinoDialogAction>[
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      onPressed: () => Navigator.pop(context),
                      child: const Text('아니오'),
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.remove('userId'); // Clearing userId
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (builder) => LoginPage(),
                        //   ),
                        // );
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => LoginPage()),
                            (route) => false);
                      },
                      child: Text('예'),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 16),
                  Text(
                    '로그아웃',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
