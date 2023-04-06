import 'package:get/get.dart';
import 'package:process_run/shell.dart';

class BuildController extends GetxController {
  late Shell shell;
  RxString showingLog = "".obs;
  RxBool showLoading = false.obs;
  RxString loadingActionName = "flutter --version".obs;
  String env = '';
  String appDir = '';
  String flutterDir = '';

  @override
  void onInit() {
    super.onInit();
    shell = Shell();
    env = Get.arguments['env'];
    appDir = Get.arguments['appDir'];
    flutterDir = Get.arguments['flutterDir'];
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await runShell('flutter --version');
  }

  Future<void> runShell(String script) async {
    showLoading.value = true;
    var shellResult = await shell.run(script);
    addLog(shellResult.outText);
    showLoading.value = false;
  }

  addLog(String str) {
    showingLog.value += str;
    showingLog.value += '\n';
  }
}
