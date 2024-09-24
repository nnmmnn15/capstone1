import 'dart:convert';
import 'package:frige_app/model/user.dart';
import 'package:frige_app/vm/hash_password.dart';
import 'package:http/http.dart' as http;

class UserHandler {
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
      return [responseData['user_check'], responseData['user_key']];
    } else {
      return null;
    }
  }
}
