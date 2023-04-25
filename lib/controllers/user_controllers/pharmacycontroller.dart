import 'dart:math';

import 'package:get/get.dart';

class PharmacyController extends GetxController {
  List<Map<String, dynamic>> medicin = List.generate(
      14,
      (index) => {
            "image":
                "https://media.istockphoto.com/id/1338513385/photo/white-pills-or-tablets-for-virus-on-blue-background.jpg?s=1024x1024&w=is&k=20&c=obmywHZqEEse2Nc9ikyP0zNxk_ulHjpnkswQv52vRd8=",
            "name": "medicin name",
            "price": Random().nextInt(50)
          });

  //pharmacys
  RxString pharmacy_search_key="".obs;
  RxList pharmacys=[].obs;


  Future<void> change_search_key(String skey)async{
    pharmacy_search_key.value=skey.toString();
    update();

  }
}
