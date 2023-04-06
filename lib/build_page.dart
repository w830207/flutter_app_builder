import 'package:flutter/material.dart';
import 'build_controller.dart';
import 'package:get/get.dart';

class BuildPage extends StatelessWidget {
  BuildPage({Key? key}) : super(key: key);

  final BuildController controller = Get.put(BuildController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${controller.env} 打包"),
      ),
      body: Center(
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.8,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Obx(() {
                  return Column(
                    children: [
                      SelectableText(controller.showingLog.value),
                      Visibility(
                        visible: controller.showLoading.value,
                        child: Column(
                          children: [
                            const CircularProgressIndicator(),
                            Text("執行 ${controller.loadingActionName.value}")
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
