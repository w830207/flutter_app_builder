import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'build_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final TextEditingController myController =
      TextEditingController(text: "專案目錄地址");

  @override
  Widget build(BuildContext context) {
    String flutterDir = '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("初始選擇"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: myController,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: OutlinedButton(
                child: const Text('1。選中專案檔案夾'),
                onPressed: () async {
                  myController.text = await getDirectoryPath() ?? "";
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: OutlinedButton(
                child: const Text('2。若未設定環境變量，則選取flutter sdk檔案夾'),
                onPressed: () async {
                  flutterDir = await getDirectoryPath() ?? '';
                  if (flutterDir.isNotEmpty) flutterDir += '/bin/';
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: OutlinedButton(
                child: const Text('3。去打包UAT'),
                onPressed: () {
                  Get.to(() => BuildPage(), arguments: {
                    'env': 'DEV',
                    'appDir': myController.text,
                    'flutterDir': flutterDir,
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: OutlinedButton(
                child: const Text('4。去打包PROD'),
                onPressed: () {
                  Get.to(() => BuildPage(), arguments: {
                    'env': 'PROD',
                    'appDir': myController.text,
                    'flutterDir': flutterDir,
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
