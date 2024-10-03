import 'package:capstone_fridge_app/vm/user_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserModify extends StatelessWidget {
  UserModify({super.key});

  final TextEditingController curPwController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController verifyPwController = TextEditingController();

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final userHandler = Get.put(UserHandler());
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '회원정보 수정',
            style: TextStyle(
              color: Color(0xFF2E7D32), // 자연을 연상시키는 초록색
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent, // 투명한 배경 색상
          elevation: 0, // 그림자 없앰
        ),
        body: GetBuilder<UserHandler>(
          builder: (controller) {
            return SingleChildScrollView(
              child: Center(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 50, 16, 0),
                    child: Obx(
                      () {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                controller: curPwController,
                                onChanged: (value) {
                                  userHandler.checkPassword(value);
                                },
                                decoration: InputDecoration(
                                  labelText: '현재 비밀번호',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  errorText: userHandler.curError.value.isEmpty
                                      ? null
                                      : controller.curError.value,
                                ),
                                obscureText: true,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                controller: pwController,
                                decoration: InputDecoration(
                                  labelText: '새로운 비밀번호',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                obscureText: true,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                controller: verifyPwController,
                                onChanged: (value) {
                                  userHandler.checkVerifyPw(
                                      pwController.text, value);
                                },
                                decoration: InputDecoration(
                                  labelText: '비밀번호 확인',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  errorText:
                                      userHandler.verifyError.value.isEmpty
                                          ? null
                                          : controller.verifyError.value,
                                ),
                                obscureText: true,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                modifyPasswordButton(userHandler);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF2E7D32), // 버튼 배경색 초록색으로 변경
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: const Text(
                                '저장',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    )),
              ),
            );
          },
        ),
      ),
    );
  }

  // --- Functions ---
  modifyPasswordButton(UserHandler userHandler) async {
    if (pwController.text.isNotEmpty &&
        curPwController.text.isNotEmpty &&
        verifyPwController.text.isNotEmpty &&
        userHandler.curError.value.isEmpty &&
        userHandler.verifyError.value.isEmpty) {
      // 변경
      await userHandler.modifyPassword(verifyPwController.text);
      Get.back();
    }
    print('변경 실패');
  }
} // End
