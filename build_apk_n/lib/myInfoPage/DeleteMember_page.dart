import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:build_apk_n/loginPage/loginMainPage.dart';
import 'package:build_apk_n/config/hashPassword.dart';
import 'package:google_fonts/google_fonts.dart';

class WithdrawPage extends StatefulWidget {
  final String userId;
  final String userPw;

  const WithdrawPage({Key? key, required this.userId, required this.userPw})
      : super(key: key);

  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _withdrawUser(BuildContext context) async {
    final String enteredPassword = _passwordController.text;
    final String hashedPassword = hashPassword(enteredPassword);
    //final url = Uri.parse('http://127.0.0.1:5000/withdraw');
    //final url = Uri.parse('http://192.168.0.19:5000/withdraw');
    final url = Uri.parse('http://172.20.10.5:5000/withdraw');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('회원탈퇴'),
          content: Text('정말로 회원탈퇴를 하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                try {
                  if (hashedPassword == widget.userPw) {
                    final response = await http.delete(
                      url,
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(<String, String>{
                        'userId': widget.userId,
                        'password': hashedPassword,
                      }),
                    );

                    if (response.statusCode == 200) {
                      Navigator.of(context).pop(); // 다이얼로그 닫기
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('회원 탈퇴 성공'),
                            content: Text('회원 탈퇴가 완료되었습니다.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // 회원탈퇴 알림창 닫기
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  );
                                },
                                child: Text('확인'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      print('Failed to withdraw user: ${response.statusCode}');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('회원 탈퇴 실패'),
                            content: Text('회원 탈퇴를 실패했습니다. 다시 시도해주세요.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('확인'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    print('Entered password does not match');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('비밀번호 불일치'),
                          content: Text('입력한 비밀번호가 일치하지 않습니다. 다시 시도해주세요.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('확인'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } catch (e) {
                  print('Error: $e');
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('에러'),
                        content: Text('회원 탈퇴 중 오류가 발생했습니다.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('확인'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('확인'),
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
        title: Text('회원탈퇴'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: '현재 비밀번호',
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
                _withdrawUser(context);
              },
              child: Text(
                '회원탈퇴',
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
    );
  }
}
