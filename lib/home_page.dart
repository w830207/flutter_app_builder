import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final TextEditingController myController = TextEditingController(
      text: "/Users/wangchenbo/StudioProjects/lilian_yabo");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("請輸入專案目錄地址"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SelectableText(
                "請輸入專案目錄地址，如：/Users/wangchenbo/StudioProjects/lilian_vietvip_pro"),
            TextField(controller: myController),
            OutlinedButton(
              child: const Text('或選中專案'),
              onPressed: () async {
                myController.text = await getDirectoryPath() ?? "";
              },
            ),
            OutlinedButton(
              child: const Text('去打包UAT'),
              onPressed: () {
                // Get.to(() => BuildPage(
                //       appDir: myController.text,
                //       env: "UAT",
                //     ));
              },
            ),
            OutlinedButton(
              child: const Text('去打包PROD'),
              onPressed: () {
                // Get.to(() => BuildPage(
                //       appDir: myController.text,
                //       env: "PROD",
                //     ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
