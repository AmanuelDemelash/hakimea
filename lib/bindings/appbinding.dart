import 'package:get/get.dart';
import 'package:hakimea/controllers/connectivity.dart';
import 'package:hakimea/controllers/locationcontrollers.dart';
import 'package:hakimea/controllers/notification_controller.dart';
import 'package:hakimea/controllers/splashcontroller.dart';
import 'package:hakimea/controllers/translationcontroller.dart';
import 'package:hakimea/controllers/user_controllers/medcincontroller.dart';
import 'package:hakimea/controllers/user_controllers/nearbycontrollers.dart';
import 'package:hakimea/controllers/user_controllers/ordercontroller.dart';
import 'package:hakimea/controllers/user_controllers/ordermedicincontroller.dart';
import 'package:hakimea/controllers/user_controllers/pharmacycontroller.dart';
import '../controllers/user_controllers/doctorprofilecontroller.dart';
import '../controllers/user_controllers/historycontroller.dart';
import '../controllers/user_controllers/homepagecontroller.dart';
import '../controllers/user_controllers/logincontroller.dart';
import '../controllers/user_controllers/myappointmentcontroller.dart';
import '../controllers/user_controllers/payment_controllers.dart';
import '../controllers/user_controllers/signupcontroller.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
    Get.put(LoginController());
    Get.put(SignUpController());
    Get.put(HomePageController());
    Get.put(CheekConnecctivityController());
    Get.put(DoctorProfileController());
    Get.put(MyappointmentController());
    Get.put(HistoryController());
    Get.put(Locationcontrollers());
    Get.put(TransalationControlers());
    Get.put(PaymentControllers());
    Get.put(NotificationController());
    Get.put(NearByController());
    Get.put(OrderController());
    Get.put(PharmacyController());
    Get.put(OrderMedicinController());
    Get.put(MedicinController());
  }
}
