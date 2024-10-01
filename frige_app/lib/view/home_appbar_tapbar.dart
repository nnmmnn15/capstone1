// import 'package:flutter/material.dart';
// import 'package:frige_app/view/fridge_log.dart';
// import 'package:frige_app/view/my_info/my_info_page.dart';
// import 'package:google_fonts/google_fonts.dart';

// class HomeAppbarTapbar extends StatefulWidget {
//   const HomeAppbarTapbar({super.key});

//   @override
//   State<HomeAppbarTapbar> createState() => _HomeAppbarTapbarState();
// }

// class _HomeAppbarTapbarState extends State<HomeAppbarTapbar>
//     with SingleTickerProviderStateMixin {
//   late TabController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'DESH',
//           style: GoogleFonts.pacifico(
//             color: const Color(0xFF2E7D32), // 자연을 연상시키는 초록색
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true, // 제목을 가운데로 정렬
//         backgroundColor: Colors.transparent,
//         automaticallyImplyLeading: false,
//         elevation: 0,
//       ),
//       body: TabBarView(
//         controller: controller,
//         children: const [
//           FridgeLog(),
//           MyInfoPage(),
//         ],
//       ),
//       bottomNavigationBar: SizedBox(
//         child: TabBar(
//           controller: controller,
//           labelColor: const Color(0xFF2E7D32),
//           indicatorColor: const Color(0xFF2E7D32),
//           unselectedLabelColor: Colors.grey,
//           tabs: const [
//             Tab(
//               icon: Icon(Icons.inventory),
//               text: '재고 목록',
//             ),
//             Tab(
//               icon: Icon(Icons.person),
//               text: '내 정보',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
