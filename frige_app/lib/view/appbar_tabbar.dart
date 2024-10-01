import 'package:flutter/material.dart';
import 'package:frige_app/view/fridge_log.dart';
import 'package:frige_app/view/my_info/my_info_page.dart';
import 'package:google_fonts/google_fonts.dart';

class AppbarTabbar extends StatelessWidget {
  const AppbarTabbar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'DESH',
            style: GoogleFonts.pacifico(
              color: const Color(0xFF2E7D32), // 자연을 연상시키는 초록색
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            FridgeLog(),
            MyInfoPage(),
          ],
        ),
        bottomNavigationBar: const SizedBox(
          child: TabBar(
            labelColor: Color(0xFF2E7D32),
            indicatorColor: Color(0xFF2E7D32),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                icon: Icon(Icons.inventory),
                text: '재고 목록',
              ),
              Tab(
                icon: Icon(Icons.person),
                text: '내 정보',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
