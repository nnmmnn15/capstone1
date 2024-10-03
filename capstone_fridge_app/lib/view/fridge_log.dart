import 'package:capstone_fridge_app/model/use_history.dart';
import 'package:capstone_fridge_app/vm/fridge_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FridgeLog extends StatelessWidget {
  const FridgeLog({super.key});

  @override
  Widget build(BuildContext context) {
    final fridgeHandler = Get.put(FridgeHandler());
    return Scaffold(
      body: GetBuilder<FridgeHandler>(
        builder: (controller) {
          return FutureBuilder(
            future: controller.fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error : ${snapshot.error}'),
                );
              } else {
                return Obx(
                  () {
                    return RefreshIndicator(
                      onRefresh: () async {
                        controller.fetchData();
                      },
                      child: ListView.builder(
                        itemCount: fridgeHandler.useHistories.length,
                        itemBuilder: (context, index) {
                          UseHistory useHistory =
                              fridgeHandler.useHistories[index];
                          return ListTile(
                            leading: Text(
                              useHistory.userName,
                              style: const TextStyle(fontSize: 15),
                            ),
                            title: Text(
                                '${useHistory.prdName} ${useHistory.quantity > 0 ? "+${useHistory.quantity}" : useHistory.quantity}'),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    "${useHistory.usageDate.year}년 ${useHistory.usageDate.month.toString().padLeft(2, '0')}월 ${useHistory.usageDate.day.toString().padLeft(2, '0')}일"),
                                Text(
                                    "${useHistory.usageDate.hour.toString().padLeft(2, '0')}시 ${useHistory.usageDate.minute.toString().padLeft(2, '0')}분 ${useHistory.usageDate.second.toString().padLeft(2, '0')}초"),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
