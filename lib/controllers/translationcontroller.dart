import 'package:get/get.dart';

class TransalationControlers extends GetxController {
  var current_local = 'en'.obs;

  change_local(String loc) {
    // BuildContext().setLocale(Locale(loc));
  }

  // theam
  var is_dark = false.obs;
}
