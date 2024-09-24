import 'dart:convert';
import 'package:http/http.dart' as http;

class FridgeHandler {
  Future fetchData() async {
    final response =
        await http.get(Uri.parse('http://192.168.45.198:5000/data'));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      List result = responseData["result"];
      print(result);
      /* 
      [[스프라이트, 1, 민철, Tue, 18 Jun 2024 10:43:00 GMT], [포카리스웨트, 1, 민철, Tue, 18 Jun 2024 10:43:00 GMT], 
      [스프라이트, -1, 민철, Tue, 18 Jun 2024 10:44:00 GMT], [포카리스웨트, -1, 민철, Tue, 18 Jun 2024 10:44:00 GMT], 
      [스프라이트, 1, 민철, Tue, 18 Jun 2024 10:44:00 GMT]] 
      */
      return result;
    } else {}
  }
}
