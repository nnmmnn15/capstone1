import 'package:flutter/material.dart';
import 'package:build_apk_n/loginPage/loginMainPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin(); // initState에서 자동으로 로그인 페이지로 이동하도록 설정
  }

  void _navigateToLogin() {
    // 일정 시간이 지난 후에 자동으로 로그인 페이지로 이동
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFFBFE1FF), // 연한 파랑색 배경
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              // 로고 이미지 추가
              'assets/frigelogo.png',
              width: 150,
              height: 150,
            ),
            // SizedBox(height: 20), // 간격 조정
            // CircularProgressIndicator(), // 원형 프로그레스 바
            // SizedBox(height: 20), // 간격 조정
            // Text(
            //   '로딩 중...',
            //   style: TextStyle(fontSize: 20),
            // ),
          ],
        ),
      ),
    );
  }
}
