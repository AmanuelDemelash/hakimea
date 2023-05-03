import 'package:get/get.dart';
import 'dart:math';

class PharmacyController extends GetxController {
  Rx<List> medicin = Rx<List>([]);

  //pharmacys
  RxString pharmacy_search_key="".obs;
  RxList pharmacys=[].obs;


  Future<void> change_search_key(String skey)async{
    pharmacy_search_key.value=skey.toString();
    update();

  }

  // calculate distance b/n pharmacy and user
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    var result = 12742 * asin(sqrt(a));
    return result.ceilToDouble();
  }
}
