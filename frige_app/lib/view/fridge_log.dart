import 'package:flutter/material.dart';
import 'package:frige_app/vm/fridge_handler.dart';

class FridgeLog extends StatefulWidget {
  const FridgeLog({super.key});

  @override
  State<FridgeLog> createState() => _FridgeLogState();
}

class _FridgeLogState extends State<FridgeLog> {
  final FridgeHandler handler = FridgeHandler();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () => handler.fetchData(),
              child: Text('test'),
            ),
          ],
        ),
      ),
    );
  }
}
