import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class CheekConnecctivityController extends GetxController {
  var has_connecction = false.obs;
  var subscription;

  @override
  void onInit() async {
    super.onInit();
    cheekinternet();
  }

  Future<void> cheekinternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      has_connecction.value = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      has_connecction.value = true;
    } else {
      Get.snackbar("", "connection lost",
          icon: const FaIcon(FontAwesomeIcons.wifi));
      has_connecction.value = false;
    }

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile) {
        has_connecction.value = true;
      } else if (result == ConnectivityResult.wifi) {
        has_connecction.value = true;
      } else {
        has_connecction.value = false;
        Get.snackbar("", "connection lost",
            icon: const FaIcon(FontAwesomeIcons.wifi));
      }
    });
  }

  @override
  void ond() {
    super.onClose();
    subscription.cancel();
  }
}
