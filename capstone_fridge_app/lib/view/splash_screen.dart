import 'package:capstone_fridge_app/view/sign/login_page.dart';
import 'package:capstone_fridge_app/vm/user_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final userHandler = Get.put(UserHandler());

  void _navigateToLogin() {
    Future.delayed(
      const Duration(seconds: 3),
      () => Get.offAll(
        LoginPage(),
        arguments: userHandler.saveUserId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    userHandler.getSaveId();
    _navigateToLogin();
    return Scaffold(
      body: Center(
        child: Image.asset(
          "images/frigelogo.png",
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
