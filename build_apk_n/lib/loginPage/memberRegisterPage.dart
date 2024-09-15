import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:build_apk_n/config/hashPassword.dart';
import 'package:build_apk_n/loginPage/loginMainPage.dart'; // 로그인 페이지 파일 추가
import 'package:google_fonts/google_fonts.dart';

class MemberRegisterPage extends StatefulWidget {
  const MemberRegisterPage({Key? key}) : super(key: key);

  @override
  State<MemberRegisterPage> createState() => _MemberRegisterState();
}

class _MemberRegisterState extends State<MemberRegisterPage> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordVerifyingController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();

  Future<void> signUp(BuildContext context) async {
    final String id = userIdController.text;
    final String password = passwordController.text;
    final String confirmPassword = passwordVerifyingController.text;
    final String name = nameController.text;

    // 입력값이 비어 있는지 검증
    if (id.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        name.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('알림'),
            content: Text('모든 입력란을 채워주세요.'),
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

    // 아이디 중복 확인
    final url = Uri.parse('http://172.20.10.5:5000/check_id');
    final response = await http.post(
      url,
      body: jsonEncode({'id': id}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final isDuplicate = responseData['isDuplicate'];

      if (isDuplicate) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('알림'),
              content: Text('이미 사용 중인 아이디입니다.'),
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('알림'),
            content: Text('아이디 중복 확인 중 오류가 발생했습니다.'),
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

    // 비밀번호 일치 확인
    if (password != confirmPassword) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('알림'),
            content: Text('입력한 비밀번호가 일치하지 않습니다.'),
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

    // 회원가입 요청
    final signUpUrl = Uri.parse('http://172.20.10.5:5000/signup');
    final hash = hashPassword(password);
    final signUpResponse = await http.post(
      signUpUrl,
      body: jsonEncode({'id': id, 'password': hash, 'name': name}),
      headers: {'Content-Type': 'application/json'},
    );

    if (signUpResponse.statusCode == 200) {
      final signUpData = jsonDecode(signUpResponse.body);
      final status = signUpData['status'];
      final message = signUpData['message'];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('알림'),
            content: Text(message),
            actions: [
              TextButton(
                child: Text('닫기'),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (status == 'success') {
                    // 회원가입 성공 시 로그인 페이지로 이동
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                      (route) => false, // 모든 이전 라우트를 제거
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('알림'),
            content: Text('회원가입 중 오류가 발생했습니다.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DESH',
          style: GoogleFonts.pacifico(
            color: Color(0xFF2E7D32), // 자연을 연상시키는 초록색
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // 제목을 가운데로 정렬
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '회원가입',
                  style: GoogleFonts.pacifico(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32), // 자연을 연상시키는 초록색
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    width: 300,
                    child: CupertinoTextField(
                      controller: userIdController,
                      placeholder: '아이디를 입력해주세요',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSans(fontSize: 16),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    width: 300,
                    child: CupertinoTextField(
                      controller: passwordController,
                      placeholder: '비밀번호를 입력해주세요',
                      textAlign: TextAlign.center,
                      obscureText: true,
                      style: GoogleFonts.notoSans(fontSize: 16),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    width: 300,
                    child: CupertinoTextField(
                      controller: passwordVerifyingController,
                      placeholder: '비밀번호를 다시 입력해주세요',
                      textAlign: TextAlign.center,
                      obscureText: true,
                      style: GoogleFonts.notoSans(fontSize: 16),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    width: 300,
                    child: CupertinoTextField(
                      controller: nameController,
                      placeholder: '이름을 입력해주세요',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSans(fontSize: 16),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // 뒤로가기 기능 추가
                        },
                        child: Text(
                          '뒤로가기',
                          style: GoogleFonts.notoSans(
                            color: Color(0xFF2E7D32), // 자연을 연상시키는 초록색
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () => signUp(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2E7D32), // 배경색
                          padding:
                              EdgeInsets.symmetric(vertical: 9, horizontal: 25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          '회원가입',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
