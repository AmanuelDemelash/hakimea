import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/myquery.dart';
import 'package:hakimea/controllers/user_controllers/myappointmentcontroller.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

import 'widgets/appoin_detail_shimmer.dart';

class MyappointmentDetail extends StatefulWidget {
  MyappointmentDetail({super.key});

  @override
  State<MyappointmentDetail> createState() => _MyappointmentDetailState();
}

class _MyappointmentDetailState extends State<MyappointmentDetail> {
  late int appo_id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appo_id = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.whitesmoke,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "My Appointment",
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
          child: Query(
            options: QueryOptions(
              document: gql(Myquery.appo_detail),
              variables: {"id": appo_id},
            ),
            builder: (result, {fetchMore, refetch}) {
              if (result.isLoading) {
                return const appoi_detail_shimmer();
              }

              Map<String, dynamic>? appointment =
                  result.data!["appointments_by_pk"];

              if (appointment != null && appointment.isNotEmpty) {
                Get.find<MyappointmentController>().reviewed_doctor.value =
                    result.data!["appointments_by_pk"]["doctor"]["id"];
              }
              return AnimationLimiter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // doc profile
                    AnimationConfiguration.staggeredList(
                        position: 0,
                        duration: const Duration(milliseconds: 300),
                        child: SlideAnimation(
                            child: FadeInAnimation(
                                child: AnimatedContainer(
                          duration: const Duration(seconds: 2),
                          width: Get.width,
                          height: 120,
                          margin: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 10,
                          ),
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: InstaImageViewer(
                                  backgroundIsTransparent: true,
                                  child: CachedNetworkImage(
                                    width: 60,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    imageUrl: result.data!["appointments_by_pk"]
                                        ["doctor"]["profile_image"]["url"],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.loose,
                                          child: Text(
                                              "Dr ${result.data!["appointments_by_pk"]["doctor"]["full_name"]}"),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        appointment!["doctor"]["is_online"] ==
                                                true
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: Constants.primcolor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: const Text(
                                                  "online",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                ),
                                              )
                                            : Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: Colors.red.shade400,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: const Text(
                                                  "offline",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                ),
                                              )
                                      ],
                                    ),
                                    const Divider(
                                      thickness: 1,
                                      color: Colors.black12,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          result.data!["appointments_by_pk"]
                                                  ["doctor"]["speciallities"]
                                              ["speciallity_name"],
                                          style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 13),
                                        ),
                                        Text(
                                          result.data!["appointments_by_pk"]
                                              ["doctor"]["current_hospital"],
                                          style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )))),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: Get.width,
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AnimationConfiguration.staggeredList(
                            position: 0,
                            duration: const Duration(milliseconds: 300),
                            child: SlideAnimation(
                              child: FadeInAnimation(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Constants.primcolor
                                              .withOpacity(0.3),
                                          shape: BoxShape.circle),
                                      child: const Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.peopleGroup,
                                          color: Constants.primcolor,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    result.data!["appointments_by_pk"]["doctor"]
                                                ["appointments"] ==
                                            null
                                        ? const Text("0")
                                        : Text(
                                            result
                                                .data!["appointments_by_pk"]
                                                    ["doctor"]["appointments"]
                                                .length
                                                .tostring,
                                            style: const TextStyle(
                                                color: Constants.primcolor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text(
                                      "Patients",
                                      style: TextStyle(color: Colors.black54),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          AnimationConfiguration.staggeredList(
                            position: 1,
                            duration: const Duration(milliseconds: 300),
                            child: SlideAnimation(
                              child: FadeInAnimation(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Constants.primcolor
                                              .withOpacity(0.3),
                                          shape: BoxShape.circle),
                                      child: const Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.graduationCap,
                                          color: Constants.primcolor,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      result.data!["appointments_by_pk"]
                                              ["doctor"]["experience_year"]
                                          .toString(),
                                      style: const TextStyle(
                                          color: Constants.primcolor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text(
                                      "Year experience",
                                      style: TextStyle(color: Colors.black54),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          AnimationConfiguration.staggeredList(
                            position: 2,
                            duration: const Duration(milliseconds: 300),
                            child: SlideAnimation(
                              child: FadeInAnimation(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Constants.primcolor
                                              .withOpacity(0.3),
                                          shape: BoxShape.circle),
                                      child: const Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.star,
                                          color: Constants.primcolor,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      result.data!["appointments_by_pk"]
                                              ["doctor"]["rate"]
                                          .toString(),
                                      style: const TextStyle(
                                          color: Constants.primcolor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text(
                                      "rating",
                                      style: TextStyle(color: Colors.black54),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          AnimationConfiguration.staggeredList(
                            position: 2,
                            duration: const Duration(milliseconds: 300),
                            child: SlideAnimation(
                              child: FadeInAnimation(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Constants.primcolor
                                              .withOpacity(0.3),
                                          shape: BoxShape.circle),
                                      child: const Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.message,
                                          color: Constants.primcolor,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    result.data!["appointments_by_pk"]["doctor"]
                                                ["reviews"] ==
                                            []
                                        ? const Text("0")
                                        : Text(
                                            result
                                                .data!["appointments_by_pk"]
                                                    ["doctor"]["reviews"]
                                                .length
                                                .toString(),
                                            style: const TextStyle(
                                                color: Constants.primcolor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text(
                                      "reviews",
                                      style: TextStyle(color: Colors.black54),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // appointment time
                    AnimationConfiguration.staggeredList(
                      position: 2,
                      duration: const Duration(milliseconds: 300),
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: Container(
                            width: Get.width,
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Appointment Time",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 14,
                                ),
                                Text(
                                  result.data!["appointments_by_pk"]["date"],
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                Text(
                                  result.data!["appointments_by_pk"]["time"],
                                  style: const TextStyle(color: Colors.black54),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // patient info
                    AnimationConfiguration.staggeredList(
                      position: 3,
                      duration: const Duration(milliseconds: 300),
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: Container(
                            width: Get.width,
                            height: 200,
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Patient Information",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 14,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Full Name :",
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      result.data!["appointments_by_pk"]
                                          ["patient"]["full_name"],
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Age :",
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      result.data!["appointments_by_pk"]
                                              ["patient"]["age"]
                                          .toString(),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const Text(
                                  "Problem :",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Flexible(
                                  child: Text(
                                    result.data!["appointments_by_pk"]
                                        ["patient"]["problem"],
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Your Package",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    result.data!["appointments_by_pk"]["package_type"] ==
                            "video"
                        ? Container(
                            width: Get.width,
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 10),
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
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Constants.primcolor
                                              .withOpacity(0.4)),
                                      child: const Center(
                                          child: FaIcon(
                                        FontAwesomeIcons.video,
                                        color: Constants.primcolor,
                                      )),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "Video Call",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "video call with doctor",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54),
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
                                      "ETB ${result.data!["appointments_by_pk"]["price"]}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Constants.primcolor),
                                    ),
                                    Text(
                                      "/session",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : result.data!["appointments_by_pk"]["package_type"] ==
                                "voice"
                            ? Container(
                                width: Get.width,
                                margin: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Constants.primcolor
                                                  .withOpacity(0.4)),
                                          child: const Center(
                                              child: FaIcon(
                                            FontAwesomeIcons.phone,
                                            color: Constants.primcolor,
                                          )),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "voice Call",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "voice call with doctor",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black54),
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
                                          "ETB ${result.data!["appointments_by_pk"]["price"]}",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Constants.primcolor),
                                        ),
                                        Text(
                                          "/session",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                width: Get.width,
                                margin: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Constants.primcolor
                                                  .withOpacity(0.4)),
                                          child: const Center(
                                              child: FaIcon(
                                            FontAwesomeIcons.message,
                                            color: Constants.primcolor,
                                          )),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "Chat",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "char with doctor",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black54),
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
                                          "ETB ${result.data!["appointments_by_pk"]["price"]}",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Constants.primcolor),
                                        ),
                                        Text(
                                          "/session",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                    const SizedBox(
                      height: 20,
                    ),
                    // call now button
                    AnimationConfiguration.staggeredList(
                      position: 4,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        width: Get.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: ElevatedButton.icon(
                            icon: result.data!["appointments_by_pk"]
                                        ["package_type"] ==
                                    "video"
                                ? const FaIcon(
                                    FontAwesomeIcons.video,
                                    size: 15,
                                  )
                                : result.data!["appointments_by_pk"]
                                            ["package_type"] ==
                                        "voice"
                                    ? const FaIcon(
                                        FontAwesomeIcons.phone,
                                        size: 15,
                                      )
                                    : const FaIcon(
                                        FontAwesomeIcons.message,
                                        size: 15,
                                      ),
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(15)),
                            onPressed: () async {
                              result.data!["appointments_by_pk"]
                                          ["package_type"] ==
                                      "video"
                                  ? Get.toNamed("/ZegoCloudCall", arguments: {
                                      "channel":
                                          result.data!["appointments_by_pk"]
                                              ["channel"],
                                      "photo": result
                                              .data!["appointments_by_pk"]
                                          ["doctor"]["profile_image"]["url"],
                                      "full_name":
                                          result.data!["appointments_by_pk"]
                                              ["user"]["full_name"],
                                      "doc_id":
                                          result.data!["appointments_by_pk"]
                                              ["doctor"]["id"],
                                      "wallet":
                                          result.data!["appointments_by_pk"]
                                              ["doctor"]["wallet"],
                                      "price": result
                                          .data!["appointments_by_pk"]["price"],
                                      "id": result.data!["appointments_by_pk"]
                                          ["id"],
                                    })
                                  : result.data!["appointments_by_pk"]
                                              ["package_type"] ==
                                          "voice"
                                      ? Get.toNamed("/voicecll", arguments: {
                                          "channel":
                                              result.data!["appointments_by_pk"]
                                                  ["channel"],
                                          "photo":
                                              result.data!["appointments_by_pk"]
                                                      ["doctor"]
                                                  ["profile_image"]["url"],
                                          "full_name":
                                              result.data!["appointments_by_pk"]
                                                  ["user"]["full_name"],
                                          "doc_id":
                                              result.data!["appointments_by_pk"]
                                                  ["doctor"]["id"],
                                          "wallet":
                                              result.data!["appointments_by_pk"]
                                                  ["doctor"]["wallet"],
                                          "price":
                                              result.data!["appointments_by_pk"]
                                                  ["price"],
                                          "id":
                                              result.data!["appointments_by_pk"]
                                                  ["id"],
                                          "isHost": true
                                        })
                                      : Get.toNamed("/chatdetail",
                                          arguments:
                                              result.data!["appointments_by_pk"]
                                                  ["doctor"]["id"]);
                            },
                            label: Text(
                                "${result.data!["appointments_by_pk"]["package_type"]} (${result.data!["appointments_by_pk"]["date"]})"),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}
