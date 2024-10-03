import 'package:capstone_fridge_app/view/appbar_tabbar.dart';
import 'package:capstone_fridge_app/view/sign/register_page.dart';
import 'package:capstone_fridge_app/vm/user_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final GetStorage box = GetStorage();
  final UserHandler handler = UserHandler();

  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final userHandler = Get.put(UserHandler());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserHandler>(
      builder: (controller) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(seconds: 1),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, -50 + 50 * value),
                              child: Text(
                                'DESH',
                                style: GoogleFonts.pacifico(
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 40),

                      /// 수정 ////
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SizedBox(
                          width: 300,
                          child: CupertinoTextField(
                            controller: idController,
                            placeholder: '아이디를 입력해주세요',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSans(fontSize: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
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
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
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
                            value: userHandler.saveUserId,
                            onChanged: (value) {
                              userHandler.saveUserId = value!;
                              userHandler.saveIdCheck();
                            },
                          ),
                          Text(
                            '아이디 저장',
                            style: GoogleFonts.notoSans(
                              color: const Color(0xFF2E7D32), // 자연을 연상시키는 초록색
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 20),
                          OutlinedButton(
                            onPressed: () {
                              // 회원가입 이동
                              idController.text = "";
                              pwController.text = "";
                              Get.to(
                                () => const RegisterPage(),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Color(0xFF2E7D32)), // 자연을 연상시키는 초록색
                            ),
                            child: Text(
                              '계정생성',
                              style: GoogleFonts.notoSans(
                                color: const Color(0xFF2E7D32), // 자연을 연상시키는 초록색
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
                            FocusScope.of(context).unfocus();
                            // 로그인
                            List result = await handler.signInUser(
                                idController.text, pwController.text);
                            if (result[0] == 1) {
                              box.write('desh_user_key', result[1]);
                              box.write('desh_user_name', result[2]);
                              box.write('desh_user_pw', pwController.text);
                              box.write('desh_user_id', idController.text);
                              idController.text = '';
                              pwController.text = '';
                              Get.to(
                                () => const AppbarTabbar(),
                              );
                            } else {
                              popDialog('아이디 또는 비밀번호가 올바르지 않습니다.');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF2E7D32), // 자연을 연상시키는 초록색
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
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
            ),
          ),
        );
      },
    );
  }

  // --- Functions ---
  popDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text('알림'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
} // End
