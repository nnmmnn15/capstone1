import 'dart:convert';
import 'package:frige_app/model/use_history.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

class FridgeHandler extends GetxController {
  var useHistories = <UseHistory>[].obs;

  fetchData() async {
    final response =
        await http.get(Uri.parse('http://192.168.45.198:5000/data'));

    if (response.statusCode == 200) {
      final responseData = json.decode(utf8.decode(response.bodyBytes));
      List result = responseData["result"];

      List<UseHistory> returnResult = [];
      for (List data in result) {
        returnResult.add(
          UseHistory(
            prdName: data[0],
            quantity: data[1],
            userName: data[2],
            usageDate: DateTime.parse(data[3]),
          ),
        );
      }
      useHistories.value = returnResult;
    }
  }
}
