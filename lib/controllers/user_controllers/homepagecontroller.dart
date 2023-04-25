import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:hakimea/model/homepagechoice.dart';

class HomePageController extends GetxController {
  var current_bnb_item = 0.obs;
  var isdrawershow = 0.obs;
  var slider_indicator = 0.obs;
  final advancedDrawerController = AdvancedDrawerController();
  List<HomepageChoiceList> choicelist = [
    HomepageChoiceList("doc", "assets/images/doctor.png"),
    HomepageChoiceList("pharmacy", "assets/images/pharmacy.png"),
    HomepageChoiceList("medicine", "assets/images/medicine.png"),
    HomepageChoiceList("more", "assets/images/medical-prescription.png")
  ];
}
