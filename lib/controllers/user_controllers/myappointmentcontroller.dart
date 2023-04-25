import 'dart:math';

import 'package:get/get.dart';

class MyappointmentController extends GetxController {
  RxInt docid = 0.obs;
  var appointment_type = "".obs;
  var appointment_time = "".obs;
  var appointment_date = "".obs;
  var channel = "".obs;

  var patient_name = "".obs;
  var patient_age = 0.obs;
  var problem = "".obs;

  var payment_option = "".obs;
  var total_payment = 0.obs;

  var ref_no = "".obs;
  var redirect_url_chapa = "".obs;

  // reschedule
  var is_reschedule = false.obs;
  var resc_date = "".obs;
  var resc_time = "".obs;

  // schdule notif
  Rx<DateTime> schdule_date = Rx(DateTime.now());

  // complation

  var is_complating = false.obs;

  // doc w/c is contacted
  RxInt reviewed_doctor = 0.obs;
  RxDouble rate = 0.0.obs;
  RxString review = "".obs;
  var is_review = false.obs;

  // cancel appointment
  var is_cancel_appoint = false.obs;

  // chat
  var is_sending_message = false.obs;
  var is_emoje_show = false.obs;

  // appointment detail
  Rx<int> appo_id = 0.obs;

  clear_data() {
    total_payment.value = 0;
    appointment_date.value = "";
    appointment_time.value = "";
    appointment_type.value = "";
    ref_no.value = "";
    redirect_url_chapa.value = "";
    payment_option.value = "";
    patient_age.value = 0;
    patient_name.value = "";
    problem.value = "";
    channel.value = "";
    update();
  }

  generate_channel() async {
    var rand = Random().nextInt(1000);
    channel.value = "hakime$rand";
    print(channel);
    update();
  }
}
