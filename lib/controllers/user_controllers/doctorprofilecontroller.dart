import 'package:get/get.dart';

class DoctorProfileController extends GetxController {
  var current_index = 0.obs;
  List<String> selectionstoggle = ["About", "Experiance", "Review"];
  var current_speciality = 0.obs;
  var num_of_doctors = 0.obs;
  var num_of_doctors_filterd = 0.obs;

  var current_topdoc_speciality = "".obs;
  var doc_filter_search = "".obs;

  // user
  var is_updating_user = false.obs;

  // fav doc
  var is_fav = false.obs;
}
