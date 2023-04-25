import 'package:get/get.dart';

class PaymentControllers extends GetxController {
  var is_paying = false.obs;

  RxDouble webview_progress = 0.0.obs;
}
