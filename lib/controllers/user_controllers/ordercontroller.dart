import 'package:get/get.dart';

class OrderController extends GetxController {
  var pharma_payment_method = "".obs;
  var is_canceling_order = false.obs;

  var is_confirm_button_finshed = false.obs;
  var is_medicins_returned = false.obs;
}
