import 'package:get/get.dart';
import 'package:hakimea/controllers/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  var currentonbord_screen = 0.obs;
  var islogin = false.obs;
  //var token = null.obs;
  late final prefs;

  Future<void> gotonext() async {
    bool connec =
        Get.find<CheekConnecctivityController>().has_connecction.value;
    Future.delayed(const Duration(seconds: 5), () async {
      var first_time = await prefs.getBool('firsttime');
      var token = await prefs.getString("token");

      first_time == null
          ? Get.offNamed("/onbording")
          : token == null
              ? Get.offNamed("/login")
              : Get.offNamed("/mainhomepage");

    });
  }

  Future<void> user_statuss_data() async {
    prefs = await SharedPreferences.getInstance();
  }
}
