import 'dart:convert';
import 'package:capstone_fridge_app/model/user.dart';
import 'package:capstone_fridge_app/vm/hash_password.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class UserHandler extends GetxController {
  final GetStorage box = GetStorage();

  bool saveUserId = false;

  final curError = ''.obs;
  final verifyError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getSaveId();
  }

  checkPassword(String cur) {
    if (cur == '') {
      curError.value = ''; // 에러가 없을 경우 빈 문자열로 설정
    } else if (cur != box.read('desh_user_pw')) {
      curError.value = '비밀번호가 일치하지 않습니다';
    } else {
      curError.value = '';
    }
  }

  checkVerifyPw(String pw, String verify) {
    if (pw == verify || verify == '') {
      verifyError.value = ''; // 에러가 없을 경우 빈 문자열로 설정
    } else {
      verifyError.value = '비밀번호가 일치하지 않습니다';
    }
  }

  getSaveId() {
    bool? isCheck = box.read('save_check_desh');
    if (isCheck != null) {
      saveUserId = isCheck;
    }
    update();
  }

  saveIdCheck() {
    box.write('save_check_desh', saveUserId);
    update();
  }

  Future<bool> checkIdDuplicate(String id) async {
    // 아이디 중복 확인
    final url = Uri.parse('http://192.168.45.198:5000/check_id');
    final response = await http.post(
      url,
      body: jsonEncode({'id': id}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      bool isDuplicate = responseData['isDuplicate'];
      return isDuplicate;
    } else {
      return true;
    }
  }

  signUpUser(User user) async {
    final signUpUrl = Uri.parse('http://192.168.45.198:5000/signup');
    final hash = hashPassword(user.pw);
    final signUpResponse = await http.post(
      signUpUrl,
      body: jsonEncode({'id': user.id, 'password': hash, 'name': user.name}),
      headers: {'Content-Type': 'application/json'},
    );

    if (signUpResponse.statusCode == 200) {
      final signUpData = jsonDecode(signUpResponse.body);
      return [signUpData['status'], signUpData['message']];
    }
    return 0;
  }

  signInUser(String id, String pw) async {
    final url = Uri.parse('http://192.168.45.198:5000/login');
    final hash = hashPassword(pw);
    final response = await http.post(
      url,
      body: jsonEncode({'id': id, 'password': hash}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return [
        responseData['user_check'],
        responseData['user_key'],
        responseData['user_name']
      ];
    } else {
      return null;
    }
  }

  modifyPassword(password) async {
    final hash = hashPassword(password);
    final url = Uri.parse('http://192.168.45.198:5000/update_user');
    final response = await http.put(
      url,
      body: jsonEncode({'id': box.read('desh_user_id'), 'password': hash}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      box.write('desh_user_pw', password);
      // final responseData = jsonDecode(response.body);
      // final status = responseData['status'];
      // final message = responseData['message'];
    }
  }
}
