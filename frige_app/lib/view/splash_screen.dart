import 'package:flutter/material.dart';
import 'package:frige_app/view/sign/login_page.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() {
    Future.delayed(
      const Duration(seconds: 3),
      () => Get.offAll(const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
