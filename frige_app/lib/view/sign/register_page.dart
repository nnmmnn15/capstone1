import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frige_app/model/user.dart';
import 'package:frige_app/vm/user_handler.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late UserHandler handler;

  late TextEditingController idController;
  late TextEditingController pwController;
  late TextEditingController pwVerifyingController;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    handler = UserHandler();
    idController = TextEditingController();
    pwController = TextEditingController();
    pwVerifyingController = TextEditingController();
    nameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DESH',
          style: GoogleFonts.pacifico(
            color: const Color(0xFF2E7D32), // 자연을 연상시키는 초록색
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
                      controller: idController,
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
                      controller: pwController,
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
                      controller: pwVerifyingController,
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
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () async => await signUp(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2E7D32), // 배경색
                          padding:
                              EdgeInsets.symmetric(vertical: 9, horizontal: 25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
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

  // ---Functions---
  signUp() async {
    // 입력값이 비어 있는지 검증
    if (idController.text.trim().isEmpty ||
        pwController.text.trim().isEmpty ||
        pwVerifyingController.text.trim().isEmpty ||
        nameController.text.trim().isEmpty) {
      alertMessage('모든 입력란을 채워주세요.');
    } else {
      // 중복확인
      bool isDuplicate =
          await handler.checkIdDuplicate(idController.text.trim());
      if (isDuplicate) {
        alertMessage('이미 사용 중인 아이디 입니다.');
        return;
      }

      // 비밀번호 검증
      if (pwController.text.trim() != pwVerifyingController.text.trim()) {
        alertMessage('입력한 비밀번호가 일치하지 않습니다.');
        return;
      }

      User user = User(
        id: idController.text.trim(),
        pw: pwController.text.trim(),
        name: nameController.text.trim(),
      );
      var result = handler.signUpUser(user);
      if (result == 0) {
        alertMessage("회원가입 중 오류가 발생했습니다.");
      } else {
        signUpAlert(result[0], result[1])
      }
    }
  }

  alertMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('닫기'),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  signUpAlert(String state, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('닫기'),
              onPressed: () {
                Get.offAll(
                  () => 
                );
              },
            ),
          ],
        );
      },
    );
  }
} // ed
