// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:build_apk_n/loginPage/loginMainPage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'FridgeInventoryPage/FridgeInventoryPage.dart';
// import 'CameraPage/CameraExample.dart';
import 'myInfoPage/myInfoMainPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
// import 'package:camera/camera.dart';

// 기본 홈
class MyAppPage extends StatefulWidget {
  final String userId; // 사용자 ID를 저장할 변수 추가

  // 생성자를 통해 userId를 받도록 수정
  const MyAppPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<MyAppPage> createState() => MyAppState();
}

class MyAppState extends State<MyAppPage> {
  // 바텀 내비게이션 바 인덱스
  int _selectedIndex = 0;
  // 바텀 내비게이션 바의 연결될 페이지를 인덱스 순으로 나열
  final List<Widget> _navIndex = [
    FridgeInventoryPage(),
    // CameraExample(),
    MyInfoPage(userName: ""), // 사용자 이름을 전달하기 위해 초기값으로 빈 문자열 설정
  ];

  // user의 db 정보를 저장할 변수
  dynamic userData;

  @override
  void initState() {
    super.initState();
    fetchUserData(widget.userId); // 사용자 데이터 가져오기
  }

  // userId로 User의 db를 가져오는 함수
  // 사용방법 userData['user_key'] / user_key 는 db의 칼럼명
  void fetchUserData(String userId) async {
    //var url = Uri.parse('http://127.0.0.1:5000/get_user');
    //var url = Uri.parse('http://192.168.0.19:5000/get_user');
    var url = Uri.parse('http://172.20.10.5:5000/get_user');
    try {
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'id': userId}));

      if (response.statusCode == 200) {
        setState(() {
          userData = jsonDecode(response.body);
          // 사용자 이름을 가져왔을 때 MyInfoPage를 다시 빌드하여 사용자 이름을 업데이트합니다.
          _navIndex[1] = MyInfoPage(userName: userData['user_name']);
        });
      } else {
        print('Failed to load user data');
      }
    } catch (e) {
      print('Error occurred while fetching data: $e');
    }
  }

  // 바텀 내비게이션 바가 클릭되었을 때 인덱스 상태 변경
  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFFFAF3E0), // 부드러운 베이지 톤 배경색
      appBar: AppBar(
        title: Text(
          'DESH',
          style: GoogleFonts.pacifico(
            color: Color(0xFF2E7D32), // 자연을 연상시키는 초록색
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // 제목을 가운데로 정렬
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // 본문은 바텀 내비게이션 바의 인덱스에 따라 페이지 전환
      body: _navIndex.elementAt(_selectedIndex),
      // 바텀 내비게이션 바
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF2E7D32), // 자연을 연상시키는 초록색
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: '재고 목록',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.camera_alt), // 카메라 아이콘 추가
          //   label: '카메라', // 라벨은 필요에 따라 변경 가능
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '내 정보',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}
