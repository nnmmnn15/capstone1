import 'package:flutter/material.dart';
// import 'package:build_apk_n/loginPage/loginMainPage.dart';
import 'package:build_apk_n/screen_splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      //home: TokenCheck(),
      home: SplashScreen(),
    );
  }
}
