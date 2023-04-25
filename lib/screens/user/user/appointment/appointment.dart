import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/myquery.dart';
import 'package:hakimea/controllers/user_controllers/myappointmentcontroller.dart';
import 'package:hakimea/controllers/user_controllers/signupcontroller.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:hakimea/widgets/loading.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

class Appointment extends StatefulWidget {
  Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  var pagecontroller = PageController(initialPage: 0);
  final _formkey = GlobalKey<FormState>();
  TextEditingController pname = TextEditingController();
  TextEditingController page = TextEditingController();
  TextEditingController pproblem = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.whitesmoke,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Book Appointment",
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
        body: PageView(
          controller: pagecontroller,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Query(
                  options: QueryOptions(
                      document: gql(Myquery.doc_profile),
                      variables: {"id": Get.arguments}),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.isLoading) {
                      return const Center(child: loading());
                    }
                    return AnimationLimiter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimationConfiguration.staggeredList(
                            position: 0,
                            duration: const Duration(milliseconds: 300),
                            child: SlideAnimation(
                              child: FadeInAnimation(
                                child: Container(
                                  width: Get.width,
                                  height: 110,
                                  margin: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Row(children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)),
                                      child: InstaImageViewer(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              result.data!["doctors_by_pk"]
                                                  ["profile_image"]["url"],
                                          width: 110,
                                          height: 110,
                                          placeholder: (context, url) =>
                                              const Icon(Icons.image),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "Dr. ${result.data!["doctors_by_pk"]["full_name"]}",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black54),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          result.data!["doctors_by_pk"]
                                                  ["speciallities"]
                                              ["speciallity_name"],
                                          style: const TextStyle(
                                              color: Constants.primcolor,
                                              fontSize: 17),
                                        )
                                      ],
                                    )
                                  ]),
                                ),
                              ),
                            ),
                          ),
                          //date picker
                          AnimationConfiguration.staggeredList(
                            position: 1,
                            duration: const Duration(milliseconds: 300),
                            child: SlideAnimation(
                              child: FadeInAnimation(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10),
                                  width: Get.width,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Select Date*",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: DatePickerWidget(
                                          looping:
                                              false, // default is not looping
                                          firstDate:
                                              DateTime.now(), //DateTime(1960),
                                          //  lastDate: DateTime(2002, 1, 1),
                                          initialDate:
                                              DateTime.now(), // DateTime(1994),
                                          dateFormat: "dd/MMMM/yyyy",
                                          locale:
                                              DatePicker.localeFromString('et'),
                                          pickerTheme: DateTimePickerTheme(
                                            backgroundColor: Colors.white,
                                            itemTextStyle: const TextStyle(
                                                color: Constants.primcolor,
                                                fontSize: 19),
                                            dividerColor: Constants.primcolor
                                                .withOpacity(0.5),
                                          ),
                                          onChange: (dateTime, selectedIndex) {
                                            Get.find<MyappointmentController>()
                                                    .appointment_date
                                                    .value =
                                                "${dateTime.day}-${dateTime.month}-${dateTime.year}";
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        "Select Time*",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      // time picker
                                      Container(
                                        width: Get.width,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: TimePickerSpinner(
                                            is24HourMode: false,
                                            normalTextStyle: TextStyle(
                                                fontSize: 15,
                                                color: Constants.primcolor
                                                    .withOpacity(0.5)),
                                            highlightedTextStyle:
                                                const TextStyle(
                                                    fontSize: 23,
                                                    color: Constants.primcolor),
                                            spacing: 10,
                                            itemHeight: 50,
                                            isShowSeconds: false,
                                            isForce2Digits: true,
                                            minutesInterval: 10,
                                            onTimeChange: (p0) async {
                                              DateTime time = p0.toLocal();
                                              Get.find<MyappointmentController>()
                                                      .appointment_time
                                                      .value =
                                                  "${time.hour}:${time.minute}:${time.second}";
                                              Get.find<
                                                      MyappointmentController>()
                                                  .schdule_date
                                                  .value = p0.toLocal();
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // package
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "Select package*",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),

                          result.data!["doctors_by_pk"]["packages"].length == 0
                              ? const Center(
                                  child: Text("no consultancy package set.."))
                              : AnimationConfiguration.staggeredList(
                                  position: 2,
                                  duration: const Duration(milliseconds: 300),
                                  child: SlideAnimation(
                                    child: FadeInAnimation(
                                      child: Column(
                                        children: [
                                          // video package
                                          result.data!["doctors_by_pk"][
                                                      "packages"][0]["video"] ==
                                                  0
                                              ? Text("")
                                              : Container(
                                                  width: Get.width,
                                                  margin:
                                                      const EdgeInsets
                                                              .only(
                                                          left: 20,
                                                          right: 20,
                                                          bottom: 10),
                                                  padding: const EdgeInsets.all(
                                                      15),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 50,
                                                            height: 50,
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Constants
                                                                    .primcolor
                                                                    .withOpacity(
                                                                        0.4)),
                                                            child: const Center(
                                                                child: FaIcon(
                                                              FontAwesomeIcons
                                                                  .video,
                                                              color: Constants
                                                                  .primcolor,
                                                            )),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: const [
                                                              Text(
                                                                "Video Call",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                "video call with doctor",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            "ETB ${result.data!["doctors_by_pk"]["packages"][0]["video"]}",
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Constants
                                                                    .primcolor),
                                                          ),
                                                          const Text(
                                                            "/session",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black54),
                                                          ),
                                                        ],
                                                      ),
                                                      Obx(() => Radio(
                                                            value: "video",
                                                            activeColor:
                                                                Constants
                                                                    .primcolor,
                                                            groupValue: Get.find<
                                                                    MyappointmentController>()
                                                                .appointment_type
                                                                .value,
                                                            onChanged: (value) {
                                                              Get.find<
                                                                      MyappointmentController>()
                                                                  .appointment_type
                                                                  .value = value!;
                                                              Get.find<
                                                                      MyappointmentController>()
                                                                  .total_payment
                                                                  .value = result
                                                                              .data![
                                                                          "doctors_by_pk"]
                                                                      [
                                                                      "packages"]
                                                                  [0]["video"];
                                                            },
                                                          ))
                                                    ],
                                                  )),
                                          // voice package
                                          result.data!["doctors_by_pk"][
                                                      "packages"][0]["voice"] ==
                                                  0
                                              ? const Text("")
                                              : Container(
                                                  width: Get.width,
                                                  margin:
                                                      const EdgeInsets
                                                              .only(
                                                          left: 20,
                                                          right: 20,
                                                          bottom: 10),
                                                  padding: const EdgeInsets.all(
                                                      15),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 50,
                                                            height: 50,
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Constants
                                                                    .primcolor
                                                                    .withOpacity(
                                                                        0.4)),
                                                            child: const Center(
                                                                child: FaIcon(
                                                              FontAwesomeIcons
                                                                  .phone,
                                                              color: Constants
                                                                  .primcolor,
                                                            )),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: const [
                                                              Text(
                                                                "Voice Call",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                "voice call with doctor",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            "ETB ${result.data!["doctors_by_pk"]["packages"][0]["voice"]}",
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Constants
                                                                    .primcolor),
                                                          ),
                                                          const Text(
                                                            "/session",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black54),
                                                          ),
                                                        ],
                                                      ),
                                                      Obx(() => Radio(
                                                            value: "voice",
                                                            activeColor:
                                                                Constants
                                                                    .primcolor,
                                                            groupValue: Get.find<
                                                                    MyappointmentController>()
                                                                .appointment_type
                                                                .value,
                                                            onChanged: (value) {
                                                              Get.find<
                                                                      MyappointmentController>()
                                                                  .appointment_type
                                                                  .value = value!;
                                                              Get.find<
                                                                      MyappointmentController>()
                                                                  .total_payment
                                                                  .value = result
                                                                              .data![
                                                                          "doctors_by_pk"]
                                                                      [
                                                                      "packages"]
                                                                  [0]["voice"];
                                                            },
                                                          ))
                                                    ],
                                                  )),
                                          // message package
                                          result.data!["doctors_by_pk"]
                                                      ["packages"][0]["chat"] ==
                                                  0
                                              ? const Text("")
                                              : Container(
                                                  width: Get.width,
                                                  margin: const EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                      bottom: 10),
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 50,
                                                            height: 50,
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Constants
                                                                    .primcolor
                                                                    .withOpacity(
                                                                        0.4)),
                                                            child: const Center(
                                                                child: FaIcon(
                                                              FontAwesomeIcons
                                                                  .message,
                                                              color: Constants
                                                                  .primcolor,
                                                            )),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: const [
                                                              Text(
                                                                "Messaging",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                "messaging with doctor",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            "ETB ${result.data!["doctors_by_pk"]["packages"][0]["chat"]}",
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Constants
                                                                    .primcolor),
                                                          ),
                                                          const Text(
                                                            "/session",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black54),
                                                          ),
                                                        ],
                                                      ),
                                                      Obx(() => Radio(
                                                            value: "messaging",
                                                            activeColor:
                                                                Constants
                                                                    .primcolor,
                                                            groupValue: Get.find<
                                                                    MyappointmentController>()
                                                                .appointment_type
                                                                .value,
                                                            onChanged: (value) {
                                                              Get.find<
                                                                      MyappointmentController>()
                                                                  .appointment_type
                                                                  .value = value!;
                                                              Get.find<
                                                                      MyappointmentController>()
                                                                  .total_payment
                                                                  .value = result
                                                                          .data![
                                                                      "doctors_by_pk"]
                                                                  [
                                                                  "packages"][0]["chat"];
                                                            },
                                                          ))
                                                    ],
                                                  )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          // request appointment button
                          Container(
                              width: Get.width,
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: Constants.primcolor,
                                        padding: const EdgeInsets.all(15)),
                                    onPressed: () {
                                      if (Get.find<MyappointmentController>()
                                              .appointment_type
                                              .value ==
                                          "") {
                                        Get.find<SignUpController>().customsnack(
                                            "select appointment package type ..");
                                      } else {
                                        pagecontroller.jumpToPage(1);
                                      }
                                    },
                                    child: const Text(
                                      "Next",
                                    )),
                              )),
                        ],
                      ),
                    );
                  },
                )),
            // Patient Info
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                margin: const EdgeInsets.all(15),
                child: AnimationLimiter(
                  child: AnimationConfiguration.staggeredList(
                    duration: const Duration(milliseconds: 200),
                    position: 0,
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: Form(
                          key: _formkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                    left: 10, top: 20, bottom: 20),
                                child: Text(
                                  "Patient information*",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 10, bottom: 10),
                                child: Text(
                                  "patient name*",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              // name
                              TextFormField(
                                controller: pname,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    Get.find<SignUpController>()
                                        .customsnack("enter patient name");
                                  } else {
                                    return null;
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    hintText: "full name",
                                    filled: true,
                                    contentPadding: EdgeInsets.all(17),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Constants.whitesmoke),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Constants.whitesmoke),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Constants.whitesmoke),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    fillColor: Colors.white),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 10, bottom: 10),
                                child: Text(
                                  "your age*",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextFormField(
                                controller: page,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    Get.find<SignUpController>()
                                        .customsnack("enter patient age");
                                  } else {
                                    return null;
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    hintText: "age",
                                    filled: true,
                                    contentPadding: EdgeInsets.all(17),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Constants.whitesmoke),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Constants.whitesmoke),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Constants.whitesmoke),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    fillColor: Colors.white),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 10, bottom: 10),
                                child: Text(
                                  "Write your problem*",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextFormField(
                                controller: pproblem,
                                keyboardType: TextInputType.text,
                                maxLines: 12,
                                minLines: 9,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    Get.find<SignUpController>()
                                        .customsnack("write problem ");
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: const InputDecoration(
                                    hintText: "write hear",
                                    filled: true,
                                    contentPadding: EdgeInsets.all(17),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Constants.whitesmoke),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Constants.whitesmoke),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Constants.whitesmoke),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    fillColor: Colors.white),
                              ),

                              const SizedBox(
                                height: 50,
                              ),
                              // request appointment button
                              SizedBox(
                                  width: Get.width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor: Constants
                                                    .primcolor
                                                    .withOpacity(0.7),
                                                padding:
                                                    const EdgeInsets.all(15)),
                                            onPressed: () {
                                              pagecontroller.jumpToPage(0);
                                              //Get.toNamed("/payment");
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
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  backgroundColor:
                                                      Constants.primcolor,
                                                  padding:
                                                      const EdgeInsets.all(15)),
                                              onPressed: () {
                                                _formkey.currentState!.save();
                                                if (_formkey.currentState!
                                                    .validate()) {
                                                  Get.find<
                                                          MyappointmentController>()
                                                      .patient_name
                                                      .value = pname.text;
                                                  Get.find<MyappointmentController>()
                                                          .patient_age
                                                          .value =
                                                      int.parse(page.text);
                                                  Get.find<
                                                          MyappointmentController>()
                                                      .problem
                                                      .value = pproblem.text;
                                                  pagecontroller.jumpToPage(2);
                                                }
                                              },
                                              child: const Text(
                                                "Next",
                                              )),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // payment method
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                margin: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
                      child: Text(
                        "Payment options*",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
                      child: Text(
                        "select the payment option you want to use to book appointment*",
                        style: TextStyle(),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    //chapa
                    Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: const Center(
                                      child: Image(
                                    image:
                                        AssetImage("assets/images/chapa.png"),
                                    width: 50,
                                    height: 50,
                                  )),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Chapa",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "use chapa",
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.black54),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Obx(() => Radio(
                                  value: "chapa",
                                  activeColor: Constants.primcolor,
                                  groupValue:
                                      Get.find<MyappointmentController>()
                                          .payment_option
                                          .value,
                                  onChanged: (value) {
                                    Get.find<MyappointmentController>()
                                        .payment_option
                                        .value = value!;
                                  },
                                ))
                          ],
                        )),
                    const SizedBox(
                      height: 50,
                    ),
                    // request appointment button
                    SizedBox(
                        width: Get.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor:
                                          Constants.primcolor.withOpacity(0.7),
                                      padding: const EdgeInsets.all(15)),
                                  onPressed: () {
                                    pagecontroller.jumpToPage(1);
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: Constants.primcolor,
                                        padding: const EdgeInsets.all(15)),
                                    onPressed: () {
                                      if (Get.find<MyappointmentController>()
                                              .payment_option
                                              .value ==
                                          "") {
                                        Get.find<SignUpController>()
                                            .customsnack(
                                                "select payment option");
                                      } else {
                                        Get.toNamed("/paymentoverview",
                                            arguments: Get.arguments);
                                      }
                                    },
                                    child: const Text(
                                      "Next",
                                    )),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
