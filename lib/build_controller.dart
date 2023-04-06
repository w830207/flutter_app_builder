import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:process_run/shell.dart';

class BuildController extends GetxController {
  late Shell shell;
  RxString showingLog = "".obs;
  RxBool showLoading = false.obs;
  RxBool wantUpload = false.obs;
  RxString loadingActionName = "flutter --version".obs;
  String env = '';
  String appDir = '';
  String flutterDir = '';
  ShellLinesController shellLinesController = ShellLinesController();

  Map apiConfig = {
    'UAT': {'ip': '172.31.32.91', 'pw': 'MCv@!0Xd86\$g', 'dir': ''},
    'BETA': {'ip': '18.167.147.38', 'pw': 'OvO@0!0Pk1*9', 'dir': '_beta'},
    'PROD': {'ip': '192.168.20.41', 'pw': 'OvO@0!0Pk1*9', 'dir': ''},
  };

  @override
  void onInit() {
    super.onInit();
    shell = Shell(stdout: shellLinesController.sink);
    env = Get.arguments['env'];
    appDir = Get.arguments['appDir'];
    flutterDir = Get.arguments['flutterDir'];
  }

  @override
  Future<void> onReady() async {
    super.onReady();

    shellLinesController.stream.listen((event) {
      addLog(event);
    });
    await runShell('${flutterDir}flutter --version');
  }

  Future<void> runShell(
    String script, {
    String? workingDirectory,
    bool showError = true,
  }) async {
    loadingActionName.value = script;
    try {
      if (workingDirectory != null) {
        shell = Shell(
            workingDirectory: workingDirectory,
            stdout: shellLinesController.sink);
      }

      showLoading.value = true;
      await shell.run(script);
    } catch (e) {
      if (showError) {
        addLog('！！執行錯誤！！');
        addLog(e.toString());
      }
    } finally {
      showLoading.value = false;
    }
  }

  addLog(String? str) {
    if (str == null) return;
    showingLog.value += str;
    showingLog.value += '\n';
  }

  buildApk() async {
    showingLog.value = "";
    addLog("### 刪除舊的輸出資料夾 ###");
    addLog("  移除 build/app/outputs/apk/v1/");
    await runShell(
      "rm -r $appDir/build/app/outputs/apk/v1/",
      workingDirectory: appDir,
      showError: false,
    );
    addLog("  移除 build/app/outputs/apk/v2/");
    await runShell(
      "rm -r $appDir/build/app/outputs/apk/v2/",
      showError: false,
    );
    addLog("### 刪除舊的上傳資料夾 ###");
    addLog("  移除 build/app/outputs/apk/$env/");
    await runShell(
      "rm -r $appDir/build/app/outputs/apk/$env",
      showError: false,
    );

    //打包
    await runShell(
        "${flutterDir}flutter build apk --dart-define=ENVIRONMENT=$env");

    addLog("### 複製apk檔案到上傳資料夾 $env ###");
    await runShell("mkdir -p $appDir/build/app/outputs/apk/$env");
    await runShell(
        "mv $appDir/build/app/outputs/apk/v1/release/app-v1-release.apk $appDir/build/app/outputs/apk/$env/vietvip_pro.apk");
    await runShell(
        "mv $appDir/build/app/outputs/apk/v2/release/app-v2-release.apk $appDir/build/app/outputs/apk/$env/vietvip_pro_tw.apk");

    addLog("！！Apk 打包完成！！");
  }

  buildIpa() async {
    showingLog.value = "";
    addLog("### 刪除舊的輸出資料夾 ###");
    addLog("  移除 build/ios/iphoneos/$env");
    await runShell(
      "rm -r $appDir/build/ios/iphoneos/$env",
      workingDirectory: appDir,
      showError: false,
    );

    //打包
    await runShell(
        "${flutterDir}flutter build ios --no-codesign --dart-define=ENVIRONMENT=$env");

    //製成ipa
    await runShell("rm -rf build/ios/iphoneos/Payload", showError: false);
    await runShell("rm -rf build/ios/iphoneos/Payload.ipa", showError: false);
    await runShell("mkdir build/ios/iphoneos/Payload");
    await runShell(
        "mv build/ios/iphoneos/Runner.app build/ios/iphoneos/Payload/Runner.app");
    await runShell(
        "zip -r build/ios/iphoneos/Payload.ipa build/ios/iphoneos/Payload");
    await runShell("mkdir -p build/ios/iphoneos/$env");
    await runShell(
        "mv build/ios/iphoneos/Payload.ipa build/ios/iphoneos/$env/Payload.ipa");
    await runShell("rm -rf build/ios/iphoneos/Payload", showError: false);

    addLog("### IPA 準備完成，請開啟超級簽並上傳 ###");
  }

  openFinderApk() async {
    showingLog.value = "";
    await runShell("open $appDir/build/app/outputs/apk/$env");
  }

  openFinderIpa() async {
    showingLog.value = "";
    await runShell("open $appDir/build/ios/iphoneos/$env");
  }

  uploadApk() async {
    showingLog.value = "";
    await runShell("open -a Terminal");
    addLog("已開啟終端機，請使用上傳命令");
    wantUpload.value = true;

    // await runShell(
    //     "scp -P 55160 $appDir/build/app/outputs/apk/$env/vietvip_pro.apk arduser@${apiConfig[env]['ip']}:/home/vivi_promote${apiConfig[env]['dir']}/storage/app/apk");
  }

  copyCommend() async {
    await Clipboard.setData(ClipboardData(
        text:
            "scp -P 55160 $appDir/build/app/outputs/apk/$env/*.apk arduser@${apiConfig[env]['ip']}:/home/vivi_promote${apiConfig[env]['dir']}/storage/app/apk"));
    addLog("已複製上傳命令");
  }

  copyPassword() async {
    await Clipboard.setData(ClipboardData(text: apiConfig[env]['ip']));
    addLog("已複製密碼");
  }
}
