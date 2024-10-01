import 'package:flutter/material.dart';
import 'package:frige_app/view/my_info/facial_record.dart';
import 'package:frige_app/view/my_info/user_modify.dart';
import 'package:get/get.dart';

class MyInfoPage extends StatefulWidget {
  const MyInfoPage({super.key});

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
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
                SizedBox(width: 8),
                Text(
                  '***님 안녕하세요!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              // 회원 정보 수정으로 이동
              Get.to(() => UserModify());
            },
            leading: const Icon(Icons.edit),
            title: const Text('회원정보 수정'),
          ),
          ListTile(
            onTap: () {
              // 얼굴 등록으로 이동
              Get.to(() => const FacialRecord());
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
}
