import 'package:flutter/material.dart';
// import 'package:frige_app/view/appbar_tabbar.dart';
import 'package:frige_app/view/splash_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 200, 255, 202)),
          useMaterial3: true,
        ),
        home: const SplashScreen() // const SplashScreen(),
        );
  }
}
