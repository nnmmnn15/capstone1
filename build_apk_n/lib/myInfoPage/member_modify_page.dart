import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:build_apk_n/myInfoPage/myInfoMainPage.dart';
import 'package:build_apk_n/config/hashPassword.dart';
import 'package:build_apk_n/header&footer.dart';
import 'package:google_fonts/google_fonts.dart';

class MemberModifyPage extends StatefulWidget {
  final String userId;
  const MemberModifyPage({Key? key, required this.userId}) : super(key: key);

  @override
  _MemberModifyPageState createState() => _MemberModifyPageState();
}

class _MemberModifyPageState extends State<MemberModifyPage> {
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '회원정보 수정',
          style: TextStyle(color: Colors.black), // 녹색 글씨로 변경
        ),
        backgroundColor: Colors.transparent, // 투명한 배경 색상
        elevation: 0, // 그림자 없앰
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '아이디 : ${widget.userId}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: '새로운 비밀번호',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.green), // 테두리 색상 변경
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _saveChanges(context);
                },
                child: Text(
                  '저장',
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2E7D32), // 버튼 배경색 초록색으로 변경
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      //backgroundColor: Color(0xFFFAF3E0), // 배경색 변경
    );
  }

  void _saveChanges(BuildContext context) async {
    final String password = passwordController.text;

    if (password.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('알림'),
            content: Text('새로운 비밀번호를 입력하세요.'),
            actions: [
              TextButton(
                child: Text('닫기'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    //final url = Uri.parse('http://192.168.0.19:5000/update_user');
    final url = Uri.parse('http://172.20.10.5:5000/update_user');
    final hash = hashPassword(password);

    try {
      final response = await http.put(
        url,
        body: jsonEncode({'id': widget.userId, 'password': hash}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final status = responseData['status'];
        final message = responseData['message'];

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(status),
              content: Text(message),
              actions: [
                TextButton(
                  child: Text('닫기'),
                  onPressed: () {
                    Navigator.of(context).pop();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyAppPage(userId: widget.userId),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to update user information');
      }
    } catch (e) {
      print('Error: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('에러'),
            content: Text('회원정보 수정 중 오류가 발생했습니다.'),
            actions: [
              TextButton(
                child: Text('닫기'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
