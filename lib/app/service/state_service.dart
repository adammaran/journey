import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class StateService extends GetxService {
  RxInt navIndex = RxInt(0);

  Rx<ConnectivityResult>? connectivityState;
  RxBool hasInternet = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    getInitConnectivity();
    subscribeToConnectivity();
  }

  void getInitConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      hasInternet.value = true;
      connectivityState = ConnectivityResult.mobile.obs;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      hasInternet.value = true;
      connectivityState = ConnectivityResult.wifi.obs;
    } else {
      hasInternet.value = false;
      connectivityState = ConnectivityResult.none.obs;
    }
  }

  void subscribeToConnectivity() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      debugPrint('con res: ${result.toString()}');
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        hasInternet.value = true;
      } else {
        hasInternet.value = false;
      }
      connectivityState = result.obs;
    });
  }
}
