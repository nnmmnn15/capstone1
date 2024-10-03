import 'package:camera/camera.dart';
import 'package:capstone_fridge_app/view/my_info/facial_record.dart';
import 'package:capstone_fridge_app/view/my_info/user_modify.dart';
import 'package:capstone_fridge_app/vm/user_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyInfoPage extends StatelessWidget {
  MyInfoPage({super.key});

  final box = GetStorage();
  final userHandler = Get.put(UserHandler());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              '마이페이지',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey.shade300,
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                // Icon(
                //   Icons.account_circle,
                //   size: 28,
                //   color: Colors.black,
                // ),
                const SizedBox(width: 8),
                Text(
                  '${box.read('desh_user_name')}님 안녕하세요!',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              // 회원 정보 수정으로 이동
              Get.to(() => UserModify())!.then(
                (value) {
                  userHandler.curError.value = '';
                  userHandler.verifyError.value = '';
                },
              );
            },
            leading: const Icon(Icons.edit),
            title: const Text('회원정보 수정'),
          ),
          ListTile(
            onTap: () async {
              // 얼굴 등록으로 이동
              final cameras = await availableCameras();
              Get.to(
                () => const FacialRecord(),
                arguments: cameras,
              );
            },
            leading: const Icon(Icons.face_retouching_natural),
            title: const Text('얼굴 등록'),
          ),
          ListTile(
            onTap: () {
              // 회원 탈퇴으로 이동
            },
            leading: const Icon(Icons.person_off),
            title: const Text('회원탈퇴'),
          ),
          ListTile(
            onTap: () {
              // 로그아웃 알람창
              popDialog('로그아웃 하시겠습니까?');
            },
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              '로그아웃',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
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
              box.write('desh_user_key', '');
              box.write('desh_user_name', '');
              box.write('desh_user_pw', '');
              box.write('desh_user_id', '');
              Get.back();
              Get.back();
            },
            child: const Text('예'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('아니오'),
          ),
        ],
      ),
    );
  }
}
