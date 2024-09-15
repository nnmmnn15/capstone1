import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class FridgeInventoryPage extends StatefulWidget {
  @override
  _FridgeInventoryPageState createState() => _FridgeInventoryPageState();
}

class _FridgeInventoryPageState extends State<FridgeInventoryPage> {
  List<dynamic> _data = [];
  Timer? _timer;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _startPolling();
  }

  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    if (_isRefreshing) return; // 이미 새로고침 중인 경우 중복 요청을 피하기 위해 반환하기
    setState(() {
      _isRefreshing = true;
    });
    //final response = await http.get(Uri.parse('http://192.168.0.19:5000/data'));
    final response = await http.get(Uri.parse('http://172.20.10.5:5000/data'));

    if (response.statusCode == 200) {
      setState(() {
        _data = json.decode(response.body);
        _isRefreshing = false;
      });
    } else {
      setState(() {
        _isRefreshing = false;
      });
      throw Exception('Failed to load data');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('재고 목록'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _fetchData(); // 목록의 맨 아래에 도달했을 때 데이터를 가져오기
          }
          return true;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            _fetchData(); // 당겨서 새로고침이 트리거될 때 데이터를 가져오기
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('변경사항')),
                  // DataColumn(label: Text('개수변동')),
                  // DataColumn(label: Text('물품')),
                  DataColumn(label: Text('이름')),
                  DataColumn(label: Text('시간')),
                ],
                rows: _data.map((item) {
                  return DataRow(cells: [
                    DataCell(Text(item['변경사항'])),
                    // DataCell(Text(item['개수변동'].toString())),
                    // DataCell(Text(item['물품'])),
                    DataCell(Text(item['이름'])),
                    DataCell(Text(item['시간'])),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
