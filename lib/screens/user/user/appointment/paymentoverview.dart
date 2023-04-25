import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/controllers/user_controllers/signupcontroller.dart';
import 'package:hakimea/screens/user/user/appointment/widgets/inapp_webview.dart';
import '../../../../apiservice/mymutation.dart';
import '../../../../controllers/notification_controller.dart';
import '../../../../controllers/splashcontroller.dart';
import '../../../../controllers/user_controllers/myappointmentcontroller.dart';
import '../../../../controllers/user_controllers/payment_controllers.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/buttonspinner.dart';

class PaymentOverview extends StatefulWidget {
  PaymentOverview({super.key});

  @override
  State<PaymentOverview> createState() => _PaymentOverviewState();
}

class _PaymentOverviewState extends State<PaymentOverview> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();

  Future<void> _onWillPop(BuildContext context) async {
    await showDialog(
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to cancel appointment cheekout..'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Get.find<MyappointmentController>().clear_data();
              Get.offAllNamed("/mainhomepage");
            },
            child: const Text(
              'Yes',
              style: TextStyle(color: Constants.primcolor),
            ),
          ),
        ],
      ),
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onWillPop(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Appointment Overview",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const FaIcon(
                FontAwesomeIcons.angleLeft,
                color: Colors.black,
              )),
        ),
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Mutation(
                options: MutationOptions(
                  document: gql(Mymutation.insert_appointment),
                  onError: (error) {},
                  onCompleted: (data) {
                    Get.find<MyappointmentController>().clear_data();
                    Get.find<NotificationController>().crateNotification(
                        "Appointment booked",
                        "your appointment was  succesfully booked please follow your appointment");
                    Get.find<NotificationController>()
                        .crateSchdule_notification(
                            Get.find<MyappointmentController>()
                                .schdule_date
                                .value);
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        child: AlertDialog(
                          content: Container(
                            height: 280,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Image(
                                  image:
                                      AssetImage("assets/images/checked.png"),
                                  width: 100,
                                  height: 100,
                                ),
                                const Text(
                                  "Appointment Booked succesfully",
                                  style: TextStyle(color: Constants.primcolor),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: Get.width,
                                  height: 50,
                                  margin: const EdgeInsets.all(10),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Get.offAllNamed("/mainhomepage");
                                        },
                                        child: Text("OK")),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                builder: (runMutation, result) {
                  if (result!.hasException) {
                    print(result.exception.toString());
                  }
                  if (result.isLoading) {
                    return Container(
                      width: Get.width,
                      height: Get.height,
                      child: Center(
                        child: AlertDialog(
                          icon: const ButtonSpinner(),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("Appointment is being booked"),
                              Text("please wait...."),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Mutation(
                    options: MutationOptions(
                      document: gql(Mymutation.verifay_payment),
                      onError: (error) {
                        Get.find<MyappointmentController>().ref_no.value = "";
                        Get.find<MyappointmentController>()
                            .redirect_url_chapa
                            .value = "";
                      },
                      onCompleted: (data) {
                        if (data!["verifyPayment"]["status"] == "success") {
                          Get.find<MyappointmentController>()
                              .generate_channel();
                          //run book appointment mutation
                          runMutation({
                            "date": Get.find<MyappointmentController>()
                                .appointment_date
                                .value,
                            "time": Get.find<MyappointmentController>()
                                .appointment_time
                                .value,
                            "price": Get.find<MyappointmentController>()
                                .total_payment
                                .value
                                .toString(),
                            "user_id":
                                Get.find<SplashController>().prefs.getInt("id"),
                            "doctor_id": Get.arguments,
                            "package_type": Get.find<MyappointmentController>()
                                .appointment_type
                                .value,
                            "channel": Get.find<MyappointmentController>()
                                .channel
                                .value
                                .toString(),
                            "full_name": Get.find<MyappointmentController>()
                                .patient_name
                                .value,
                            "age": Get.find<MyappointmentController>()
                                .patient_age
                                .value,
                            "problem": Get.find<MyappointmentController>()
                                .problem
                                .value
                          });
                          Get.find<MyappointmentController>().ref_no.value = "";
                          Get.find<MyappointmentController>()
                              .redirect_url_chapa
                              .value = "";
                        }
                      },
                    ),
                    builder: (runMutation, result) {
                      if (result!.hasException) {
                        print(result.exception.toString());
                      }
                      if (result.isLoading) {
                        return Container(
                          width: Get.width,
                          height: Get.height,
                          child: const Center(
                            child: AlertDialog(
                              icon: ButtonSpinner(),
                              title: Text("please wait...."),
                            ),
                          ),
                        );
                      }
                      return AnimationLimiter(
                          child: Column(
                        children: [
                          // patient info
                          AnimationConfiguration.staggeredList(
                            duration: const Duration(milliseconds: 200),
                            position: 1,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: Container(
                                  width: Get.width,
                                  height: 130,
                                  padding: const EdgeInsets.all(15),
                                  margin: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Patient info.",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        "name.",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      Row(
                                        children: [
                                          Obx(() => Text(Get.find<
                                                  MyappointmentController>()
                                              .patient_name
                                              .value)),
                                        ],
                                      ),
                                      const Text(
                                        "age.",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      Obx(() => Text(
                                            Get.find<MyappointmentController>()
                                                .patient_age
                                                .value
                                                .toString(),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // appointment detail
                          AnimationConfiguration.staggeredList(
                            duration: const Duration(milliseconds: 200),
                            position: 0,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: Container(
                                  width: Get.width,
                                  height: 130,
                                  padding: const EdgeInsets.all(15),
                                  margin: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Date and time.",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Obx(
                                            () => Text(
                                              Get.find<
                                                      MyappointmentController>()
                                                  .appointment_date
                                                  .value
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "package.",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Obx(
                                            () => Text(
                                              Get.find<
                                                      MyappointmentController>()
                                                  .appointment_type
                                                  .value,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // payment detail
                          AnimationConfiguration.staggeredList(
                            duration: const Duration(milliseconds: 200),
                            position: 0,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: Container(
                                  width: Get.width,
                                  height: 180,
                                  padding: const EdgeInsets.all(15),
                                  margin: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Payment Detail.",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("amount",
                                              style: TextStyle(
                                                  color: Colors.black54)),
                                          Obx(
                                            () => Text(
                                                "ETB ${Get.find<MyappointmentController>().total_payment.value}"),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("per session",
                                              style: TextStyle(
                                                  color: Colors.black54)),
                                          Obx(() => Text(
                                              "1x${Get.find<MyappointmentController>().total_payment.value}")),
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 2,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Total amount",
                                              style: TextStyle(
                                                  color: Colors.black54)),
                                          Obx(
                                            () => Text(
                                              "ETB ${Get.find<MyappointmentController>().total_payment.value}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // payment option
                          AnimationConfiguration.staggeredList(
                            duration: const Duration(milliseconds: 200),
                            position: 0,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: Container(
                                  width: Get.width,
                                  height: 130,
                                  padding: const EdgeInsets.all(15),
                                  margin: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Payment method",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Image(
                                        image: AssetImage(
                                            "assets/images/chapa.png"),
                                        width: 100,
                                        height: 70,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          // next button
                          Container(
                            width: Get.width,
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: Constants.primcolor
                                              .withOpacity(0.7),
                                          padding: const EdgeInsets.all(15)),
                                      onPressed: () async {
                                        Get.back();
                                      },
                                      child: const FaIcon(
                                        FontAwesomeIcons.angleLeft,
                                        size: 17,
                                      )),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Obx(() => ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  enableFeedback: false,
                                                  padding:
                                                      const EdgeInsets.all(15)),
                                              onPressed: () async {
                                                Get.find<MyappointmentController>()
                                                            .ref_no
                                                            .value ==
                                                        ""
                                                    ? await Get.bottomSheet(
                                                        isDismissible: true,
                                                        isScrollControlled:
                                                            true,
                                                        ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20)),
                                                          child: BottomSheet(
                                                            backgroundColor:
                                                                Constants
                                                                    .whitesmoke,
                                                            onClosing: () {},
                                                            builder: (context) {
                                                              return Stack(
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                          Get.height /
                                                                              1.3,
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          bottom:
                                                                              10,
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20),
                                                                      child: Form(
                                                                          key: _formkey,
                                                                          child: Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              const Padding(
                                                                                padding: EdgeInsets.all(15),
                                                                                child: Image(
                                                                                  image: AssetImage("assets/images/chapa.png"),
                                                                                  width: 100,
                                                                                  height: 70,
                                                                                ),
                                                                              ),
                                                                              const Padding(
                                                                                padding: EdgeInsets.only(left: 20),
                                                                                child: Text("Please provide your informtion"),
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 20,
                                                                              ),
                                                                              TextFormField(
                                                                                controller: fname,
                                                                                keyboardType: TextInputType.text,
                                                                                validator: (value) {
                                                                                  if (value!.isEmpty) {
                                                                                    return Get.find<SignUpController>().customsnack("enter your first name");
                                                                                  } else {
                                                                                    return null;
                                                                                  }
                                                                                },
                                                                                decoration: const InputDecoration(hintText: "first name", label: Text("First Name"), filled: true, errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.all(Radius.circular(30))), contentPadding: EdgeInsets.all(17), border: OutlineInputBorder(borderSide: BorderSide(color: Constants.whitesmoke), borderRadius: BorderRadius.all(Radius.circular(30))), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Constants.whitesmoke), borderRadius: BorderRadius.all(Radius.circular(30))), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Constants.whitesmoke), borderRadius: BorderRadius.all(Radius.circular(30))), fillColor: Colors.white),
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              TextFormField(
                                                                                controller: lname,
                                                                                keyboardType: TextInputType.text,
                                                                                validator: (value) {
                                                                                  if (value!.isEmpty) {
                                                                                    return Get.find<SignUpController>().customsnack("enter your first name");
                                                                                  } else {
                                                                                    return null;
                                                                                  }
                                                                                },
                                                                                decoration: const InputDecoration(hintText: "last name", label: Text("Last Name"), filled: true, contentPadding: EdgeInsets.all(17), errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.all(Radius.circular(30))), border: OutlineInputBorder(borderSide: BorderSide(color: Constants.whitesmoke), borderRadius: BorderRadius.all(Radius.circular(30))), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Constants.whitesmoke), borderRadius: BorderRadius.all(Radius.circular(30))), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Constants.whitesmoke), borderRadius: BorderRadius.all(Radius.circular(30))), fillColor: Colors.white),
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              TextFormField(
                                                                                controller: email,
                                                                                keyboardType: TextInputType.emailAddress,
                                                                                validator: (value) {
                                                                                  if (value!.isEmpty) {
                                                                                    return Get.find<SignUpController>().customsnack("enter your first name");
                                                                                  } else {
                                                                                    return null;
                                                                                  }
                                                                                },
                                                                                decoration: const InputDecoration(hintText: "email", label: Text("Email"), filled: true, contentPadding: EdgeInsets.all(17), errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.all(Radius.circular(30))), border: OutlineInputBorder(borderSide: BorderSide(color: Constants.whitesmoke), borderRadius: BorderRadius.all(Radius.circular(30))), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Constants.whitesmoke), borderRadius: BorderRadius.all(Radius.circular(30))), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Constants.whitesmoke), borderRadius: BorderRadius.all(Radius.circular(30))), fillColor: Colors.white),
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 30,
                                                                              ),
                                                                              Mutation(
                                                                                options: MutationOptions(
                                                                                  document: gql(Mymutation.pay),
                                                                                  onCompleted: (data) async {
                                                                                    if (data!.isNotEmpty) {
                                                                                      Get.find<MyappointmentController>().ref_no.value = data["pay"]["ref_no"];
                                                                                      Get.find<MyappointmentController>().redirect_url_chapa.value = data["pay"]["redirect_url"];
                                                                                      Get.find<PaymentControllers>().is_paying.value = false;
                                                                                      Get.back();
                                                                                    }
                                                                                  },
                                                                                ),
                                                                                builder: (runMutation, result) {
                                                                                  if (result!.hasException) {
                                                                                    print(result.exception.toString());
                                                                                  }
                                                                                  if (result.isLoading) {
                                                                                    Get.find<PaymentControllers>().is_paying.value = true;
                                                                                  }
                                                                                  return SizedBox(
                                                                                    width: Get.width,
                                                                                    height: 50,
                                                                                    child: Obx(() => ClipRRect(
                                                                                          borderRadius: BorderRadius.circular(30),
                                                                                          child: ElevatedButton(
                                                                                              style: ElevatedButton.styleFrom(elevation: 0),
                                                                                              onPressed: () {
                                                                                                _formkey.currentState!.save();
                                                                                                if (_formkey.currentState!.validate()) {
                                                                                                  // run mutation pay
                                                                                                  runMutation({
                                                                                                    "amount": Get.find<MyappointmentController>().total_payment.value,
                                                                                                    "doctor_id": Get.find<MyappointmentController>().docid.value,
                                                                                                    "user_id": Get.find<SplashController>().prefs.getInt("id"),
                                                                                                    "first_name": fname.text,
                                                                                                    "last_name": lname.text,
                                                                                                    "email": email.text
                                                                                                  });
                                                                                                }
                                                                                              },
                                                                                              child: Get.find<PaymentControllers>().is_paying.value
                                                                                                  ? Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: const [
                                                                                                        ButtonSpinner(),
                                                                                                        SizedBox(
                                                                                                          width: 10,
                                                                                                        ),
                                                                                                        Text("Please wiat....")
                                                                                                      ],
                                                                                                    )
                                                                                                  : const Text("Next")),
                                                                                        )),
                                                                                  );
                                                                                },
                                                                              ),
                                                                            ],
                                                                          )),
                                                                    ),
                                                                    //cancel button
                                                                    Positioned(
                                                                      right: 25,
                                                                      top: 25,
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Get.find<PaymentControllers>()
                                                                              .is_paying
                                                                              .value = false;
                                                                          Get.back();
                                                                        },
                                                                        child:
                                                                            const Text(
                                                                          "cancel",
                                                                          style:
                                                                              TextStyle(color: Colors.red),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ]);
                                                            },
                                                          ),
                                                        ))
                                                    : await showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled:
                                                            true,
                                                        builder: (context) {
                                                          return InappWebview(
                                                              chapa_url: Get.find<
                                                                      MyappointmentController>()
                                                                  .redirect_url_chapa
                                                                  .value);
                                                        },
                                                      ).then((value) =>
                                                        runMutation({
                                                          "ref_no": Get.find<
                                                                  MyappointmentController>()
                                                              .ref_no
                                                              .value
                                                        }));
                                              },
                                              child:
                                                  Get.find<MyappointmentController>()
                                                              .ref_no
                                                              .value ==
                                                          ""
                                                      ? const Text("Next")
                                                      : const Text(
                                                          "Proced to payment")),
                                        )))
                              ],
                            ),
                          )
                        ],
                      ));
                    },
                  );
                })),
      ),
    );
  }
}
