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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.8,
              color: Colors.white,
              child: SingleChildScrollView(
                reverse: true,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: controller.buildApk,
                  child: const Text("打包Android apk"),
                ),
                TextButton(
                  onPressed: controller.buildIpa,
                  child: const Text("打包Ios ipa"),
                ),
                const Divider(),
                TextButton(
                  onPressed: controller.openFinderApk,
                  child: const Text("打開Android apk目錄"),
                ),
                TextButton(
                  onPressed: controller.openFinderIpa,
                  child: const Text("打開IOS ipa目錄"),
                ),
                const Divider(),
                TextButton(
                  onPressed: controller.uploadApk,
                  child: const Text("手動上傳apk"),
                ),
                Obx(() {
                  return AnimatedCrossFade(
                      firstChild: Column(
                        children: [
                          TextButton(
                            onPressed: controller.copyCommend,
                            child: const Text("複製上傳命令"),
                          ),
                          TextButton(
                            onPressed: controller.copyPassword,
                            child: const Text("複製密碼"),
                          ),
                        ],
                      ),
                      secondChild: const SizedBox(),
                      crossFadeState: controller.wantUpload.value
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 300));
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
