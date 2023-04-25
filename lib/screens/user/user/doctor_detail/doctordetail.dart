import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_alert/arrays.dart';
import 'package:emoji_alert/emoji_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/mymutation.dart';
import 'package:hakimea/apiservice/myquery.dart';
import 'package:hakimea/controllers/user_controllers/myappointmentcontroller.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

import '../../../../controllers/splashcontroller.dart';
import '../../../../controllers/user_controllers/doctorprofilecontroller.dart';
import 'widget/doc_profile_detail_shimmer.dart';

class DoctorDetail extends StatefulWidget {
  DoctorDetail({super.key});

  @override
  State<DoctorDetail> createState() => _DoctorDetailState();
}

class _DoctorDetailState extends State<DoctorDetail> {
  late int docId;

  @override
  void initState() {
    super.initState();
    docId = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.whitesmoke,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Colors.black,
            )),
        title: const Text(
          "Doctor profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          Mutation(
            options: MutationOptions(
              document: gql(Mymutation.add_favorite_doc),
              onCompleted: (data) {
                //Get.find<DoctorProfileController>().is_fav.value = false;
              },
            ),
            builder: (runMutation, result) {
              if (result!.hasException) {
                Get.find<DoctorProfileController>().is_fav.value = false;
              }
              if (result.isLoading) {
                Get.find<DoctorProfileController>().is_fav.value = true;
              }
              return IconButton(
                  onPressed: () {
                    if (Get.find<SplashController>().prefs.getString("token") ==
                        null) {
                      EmojiAlert(
                        alertTitle: const Text("Login",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        description: Column(
                          children: const [
                            Text("You need to login first"),
                          ],
                        ),
                        enableMainButton: true,
                        mainButtonColor: Constants.primcolor,
                        onMainButtonPressed: () {
                          Navigator.pop(context);
                          Get.offAllNamed("/login");
                        },
                        cancelable: true,
                        emojiType: EMOJI_TYPE.SAD,
                        height: 260,
                        mainButtonText: const Text("OK"),
                        animationType: ANIMATION_TYPE.ROTATION,
                      ).displayAlert(context);
                    } else {
                      // run mutation
                      runMutation({
                        "user_id":
                            Get.find<SplashController>().prefs.getInt("id"),
                        "doctor_id": docId
                      });
                    }
                  },
                  icon: Obx(() => Icon(
                        Get.find<DoctorProfileController>().is_fav.value == true
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Constants.primcolor.withOpacity(0.5),
                      )));
            },
          ),
          IconButton(
              onPressed: () {},
              icon: FaIcon(
                FontAwesomeIcons.share,
                color: Constants.primcolor.withOpacity(0.5),
              ))
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Query(
                options: QueryOptions(
                  document: gql(Myquery.doc_profile),
                  variables: {"id": docId},
                ),
                builder: (result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }
                  if (result.isLoading) {
                    return const doc_profile_detail_shimmer();
                  }

                  return AnimationLimiter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimationConfiguration.staggeredList(
                          duration: const Duration(milliseconds: 300),
                          position: 0,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: Container(
                                width: Get.width,
                                height: 200,
                                margin: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Row(children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                    child: InstaImageViewer(
                                      backgroundIsTransparent: true,
                                      child: CachedNetworkImage(
                                        imageUrl: result.data!["doctors_by_pk"]
                                            ["profile_image"]["url"],
                                        width: 140,
                                        height: 200,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // online status
                                      result.data!["doctors_by_pk"]["is_online"]
                                          ? Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: Constants.primcolor
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(40))),
                                              child: const Text(
                                                "Online",
                                                style: TextStyle(
                                                    color: Constants.primcolor),
                                              ))
                                          : const Text(""),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Dr. ${result.data!["doctors_by_pk"]["full_name"]}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Divider(
                                        thickness: 2,
                                        color: Colors.black54,
                                      ),
                                      Text(
                                        result.data!["doctors_by_pk"]
                                                ["speciallities"]
                                            ["speciallity_name"],
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54),
                                      ),
                                      Row(
                                        children: [
                                          RatingBar.builder(
                                            initialRating: 3,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: 11,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 1.0),
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Constants.primcolor,
                                            ),
                                            onRatingUpdate: (rating) {
                                              print(rating);
                                            },
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "(${result.data!["doctors_by_pk"]["reviews"] == null ? 0.toString() : result.data!["doctors_by_pk"]["reviews"].length.toString()})",
                                            style: const TextStyle(
                                                color: Constants.primcolor,
                                                fontSize: 13),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      result.data!["doctors_by_pk"]["packages"]
                                                  .length ==
                                              0
                                          ? const Text("")
                                          : Text(
                                              "ETB ${result.data!["doctors_by_pk"]["packages"][0]["video"].toString()}",
                                              style: const TextStyle(
                                                  color: Constants.primcolor,
                                                  fontSize: 16),
                                            ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  )
                                ]),
                              ),
                            ),
                          ),
                        ),
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
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: Constants.primcolor
                                                  .withOpacity(0.3),
                                              shape: BoxShape.circle),
                                          child: const Center(
                                            child: FaIcon(
                                              FontAwesomeIcons.peopleGroup,
                                              color: Constants.primcolor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          result.data!["doctors_by_pk"]
                                                      ["appointments"] ==
                                                  null
                                              ? 0.toString()
                                              : result
                                                  .data!["doctors_by_pk"]
                                                      ["appointments"]
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
                                          "Patients",
                                          style:
                                              TextStyle(color: Colors.black54),
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
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: Constants.primcolor
                                                  .withOpacity(0.3),
                                              shape: BoxShape.circle),
                                          child: const Center(
                                            child: FaIcon(
                                              FontAwesomeIcons.graduationCap,
                                              color: Constants.primcolor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          result.data!["doctors_by_pk"]
                                                  ["experience_year"]
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
                                          style:
                                              TextStyle(color: Colors.black54),
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
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: Constants.primcolor
                                                  .withOpacity(0.3),
                                              shape: BoxShape.circle),
                                          child: const Center(
                                            child: FaIcon(
                                              FontAwesomeIcons.star,
                                              color: Constants.primcolor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          result.data!["doctors_by_pk"]["rate"]
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
                                          style:
                                              TextStyle(color: Colors.black54),
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
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: Constants.primcolor
                                                  .withOpacity(0.3),
                                              shape: BoxShape.circle),
                                          child: const Center(
                                            child: FaIcon(
                                              FontAwesomeIcons.message,
                                              color: Constants.primcolor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          result.data!["doctors_by_pk"]
                                                      ["reviews"] ==
                                                  null
                                              ? 0.toString()
                                              : result
                                                  .data!["doctors_by_pk"]
                                                      ["reviews"]
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
                                          style:
                                              TextStyle(color: Colors.black54),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // working time
                        Container(
                          height: 70,
                          margin: const EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Working time",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "monday-sunday(2:00am-9:20pm)",
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // toggle buttons
                        SizedBox(
                            width: Get.width,
                            height: 40,
                            child: Obx(
                              () => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List.generate(3, (index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: 2,
                                    duration: const Duration(milliseconds: 300),
                                    child: SlideAnimation(
                                      child: FadeInAnimation(
                                        child: GestureDetector(
                                          onTap: () => Get.find<
                                                  DoctorProfileController>()
                                              .current_index
                                              .value = index,
                                          child: AnimatedContainer(
                                            duration:
                                                const Duration(seconds: 1),
                                            width: 100,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color:
                                                    Get.find<DoctorProfileController>()
                                                                .current_index
                                                                .value ==
                                                            index
                                                        ? Constants.primcolor
                                                        : Colors.white,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(14),
                                                        bottomRight:
                                                            Radius.circular(
                                                                14))),
                                            child: Center(
                                              child: Text(
                                                Get.find<
                                                        DoctorProfileController>()
                                                    .selectionstoggle[index],
                                                style: TextStyle(
                                                  color:
                                                      Get.find<DoctorProfileController>()
                                                                  .current_index
                                                                  .value ==
                                                              index
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            )),
                        // index stack
                        Obx(() => IndexedStack(
                              index: Get.find<DoctorProfileController>()
                                  .current_index
                                  .value,
                              children: [
                                //about doctor
                                SizedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(left: 20, top: 10),
                                        child: Text(
                                          "About me",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 10),
                                        child: result.data!["doctors_by_pk"]
                                                    ["bio"] ==
                                                null
                                            ? const Text(
                                                "no bio",
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              )
                                            : Text(result.data!["doctors_by_pk"]
                                                ["bio"]),
                                      ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                    ],
                                  ),
                                ),
                                //experiance of doctor
                                result.data!["doctors_by_pk"]["experiences"] ==
                                        null
                                    ? const Text(
                                        "no experience",
                                        style: TextStyle(color: Colors.black),
                                      )
                                    : Container(
                                        width: Get.width,
                                        height: 200,
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: result
                                              .data!["doctors_by_pk"]
                                                  ["experiences"]
                                              .length,
                                          itemBuilder: (context, index) {
                                            return AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              width: Get.width / 1.3,
                                              height: 160,
                                              margin: const EdgeInsets.only(
                                                  left: 15, top: 10),
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                  color: Constants.primcolor
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10))),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    result.data![
                                                                "doctors_by_pk"]
                                                            ["experiences"][
                                                        index]["hospital_name"],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Text(
                                                    "Designation",
                                                    style: TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                  Text(
                                                    result.data![
                                                                "doctors_by_pk"]
                                                            ["experiences"]
                                                        [index]["designation"],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  const Text(
                                                    "Department",
                                                    style: TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                  Text(
                                                    result.data![
                                                                "doctors_by_pk"]
                                                            ["experiences"]
                                                        [index]["department"],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  const Text(
                                                    "Employment Period",
                                                    style: TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                  Text(
                                                    "${result.data!["doctors_by_pk"]["experiences"][index]["start_date"]}- ${result.data!["doctors_by_pk"]["experiences"][index]["end_date"]}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                //review
                                SizedBox(
                                  child:
                                      result.data!["doctors_by_pk"]
                                                  ["reviews"] ==
                                              null
                                          ? Text("No review")
                                          : AnimationLimiter(
                                              child: ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: result
                                                    .data!["doctors_by_pk"]
                                                        ["reviews"]
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  return AnimationConfiguration
                                                      .staggeredList(
                                                    position: index,
                                                    duration: const Duration(
                                                        milliseconds: 375),
                                                    child: SlideAnimation(
                                                      verticalOffset: 50.0,
                                                      child: FadeInAnimation(
                                                        child:
                                                            AnimatedContainer(
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            2),
                                                                width:
                                                                    Get.width,
                                                                height: 60,
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  left: 20,
                                                                  right: 20,
                                                                  top: 10,
                                                                ),
                                                                decoration: const BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10))),
                                                                child: ListTile(
                                                                  title:
                                                                      Flexible(
                                                                    child: Text(
                                                                      result.data!["doctors_by_pk"]["reviews"]
                                                                              [
                                                                              index]
                                                                          [
                                                                          "review"],
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  ),
                                                                  subtitle:
                                                                      Text(
                                                                    result.data!["doctors_by_pk"]["reviews"][index]
                                                                            [
                                                                            "user"]
                                                                        [
                                                                        "full_name"],
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            10),
                                                                  ),
                                                                  leading:
                                                                      const CircleAvatar(
                                                                    radius: 15,
                                                                    backgroundImage:
                                                                        NetworkImage(
                                                                            ""),
                                                                  ),
                                                                  trailing:
                                                                      Column(
                                                                    children: [
                                                                      Text(result
                                                                          .data![
                                                                              "doctors_by_pk"]
                                                                              [
                                                                              "reviews"]
                                                                              [
                                                                              index]
                                                                              [
                                                                              "rate"]
                                                                          .toString()),
                                                                      RatingBar
                                                                          .builder(
                                                                        initialRating: double.parse(result
                                                                            .data!["doctors_by_pk"]["reviews"][index]["rate"]
                                                                            .toString()),
                                                                        minRating:
                                                                            1,
                                                                        direction:
                                                                            Axis.horizontal,
                                                                        allowHalfRating:
                                                                            true,
                                                                        itemCount:
                                                                            5,
                                                                        itemSize:
                                                                            11,
                                                                        itemPadding:
                                                                            const EdgeInsets.symmetric(horizontal: 1.0),
                                                                        itemBuilder:
                                                                            (context, _) =>
                                                                                const Icon(
                                                                          Icons
                                                                              .star,
                                                                          color:
                                                                              Colors.orange,
                                                                        ),
                                                                        onRatingUpdate:
                                                                            (rating) {
                                                                          print(
                                                                              rating);
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 15,
                        ),
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
                                    if (Get.find<SplashController>()
                                            .prefs
                                            .getString("token") !=
                                        null) {
                                      Get.find<MyappointmentController>()
                                          .docid
                                          .value = docId;
                                      Get.toNamed("/appointment",
                                          arguments: docId);
                                    } else {
                                      EmojiAlert(
                                        alertTitle: const Text("Login",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        description: Column(
                                          children: const [
                                            Text("You need to login first"),
                                          ],
                                        ),
                                        enableMainButton: true,
                                        mainButtonColor: Constants.primcolor,
                                        onMainButtonPressed: () {
                                          Navigator.pop(context);
                                          Get.offAllNamed("/login");
                                        },
                                        cancelable: true,
                                        emojiType: EMOJI_TYPE.SAD,
                                        height: 260,
                                        mainButtonText: const Text("OK"),
                                        animationType: ANIMATION_TYPE.ROTATION,
                                      ).displayAlert(context);
                                    }
                                  },
                                  child: const Text(
                                    "Book an Appointment",
                                  )),
                            )),
                      ],
                    ),
                  );
                },
              ))),
    );
  }
}
