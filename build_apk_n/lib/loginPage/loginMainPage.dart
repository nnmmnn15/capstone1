import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:build_apk_n/loginPage/memberRegisterPage.dart';
import 'package:build_apk_n/header&footer.dart';
import 'package:build_apk_n/config/hashPassword.dart';
import 'package:google_fonts/google_fonts.dart';

class TokenCheck extends StatefulWidget {
  const TokenCheck({Key? key});

  @override
  State<TokenCheck> createState() => _TokenCheckState();
}

class _TokenCheckState extends State<TokenCheck> {
  bool? isToken;

  @override
  void initState() {
    super.initState();
    _autoLoginCheck();
  }

  void _autoLoginCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    setState(() {
      isToken = token != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isToken == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return isToken! ? MyAppPage(userId: 'aa') : LoginPage();
    }
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  bool saveUsername = false;
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getSavedUsername();
  }

  void _getSavedUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');

    if (savedUsername != null) {
      setState(() {
        userIdController.text = savedUsername;
        saveUsername = true;
      });
    }
  }

  void _saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (saveUsername) {
      await prefs.setString('username', username);
    } else {
      await prefs.remove('username');
      await prefs.remove('userid');
    }
  }

  Future<String?> login(String userId, String password) async {
    final hash = hashPassword(password);
    //final url = Uri.parse('http://192.168.0.19:5000/login');
    final url = Uri.parse('http://172.20.10.5:5000/login');
    final response = await http.post(
      url,
      body: jsonEncode({'id': userId, 'password': hash}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];
      return token;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFFFAF3E0), // 부드러운 베이지 톤 배경색
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TweenAnimationBuilder(
                duration: Duration(seconds: 1),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (BuildContext context, double value, Widget? child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, -50 + 50 * value),
                      child: Text(
                        'DESH',
                        style: GoogleFonts.pacifico(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32), // 자연을 연상시키는 초록색
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: saveUsername,
                    onChanged: (value) {
                      setState(() {
                        saveUsername = value!;
                      });
                    },
                  ),
                  Text(
                    '아이디 저장',
                    style: GoogleFonts.notoSans(
                      color: Color(0xFF2E7D32), // 자연을 연상시키는 초록색
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 20),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MemberRegisterPage(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side:
                          BorderSide(color: Color(0xFF2E7D32)), // 자연을 연상시키는 초록색
                    ),
                    child: Text(
                      '계정생성',
                      style: GoogleFonts.notoSans(
                        color: Color(0xFF2E7D32), // 자연을 연상시키는 초록색
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () async {
                    final loginCheck = await login(
                        userIdController.text, passwordController.text);

                    if (loginCheck == null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('알림'),
                            content: Text('아이디 또는 비밀번호가 올바르지 않습니다.'),
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
                    } else {
                      _saveUsername(userIdController.text);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MyAppPage(userId: userIdController.text),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2E7D32), // 자연을 연상시키는 초록색
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    '로그인',
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
