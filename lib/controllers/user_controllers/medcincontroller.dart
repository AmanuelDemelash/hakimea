import 'package:get/get.dart';

class MedicinController extends GetxController {
  RxString medicn_search_key = "".obs;
  RxList medicins = [].obs;

  Future<void> change_search_key(String skey) async {
    medicn_search_key.value = skey.toString();
    update();
  }
}
