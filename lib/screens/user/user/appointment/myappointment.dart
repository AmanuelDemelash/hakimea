import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_alert/arrays.dart';
import 'package:emoji_alert/emoji_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/mymutation.dart';
import 'package:hakimea/apiservice/myquery.dart';
import 'package:hakimea/controllers/user_controllers/myappointmentcontroller.dart';
import 'package:hakimea/screens/user/user/appointment/widgets/pending_shimmer.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:hakimea/widgets/buttonspinner.dart';
import 'package:hakimea/widgets/someting_went_wrong.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

import '../../../../controllers/notification_controller.dart';
import '../../../../controllers/splashcontroller.dart';
import '../../../../widgets/no_appointment_found.dart';
import 'widgets/upcomming_shimmer.dart';

class Myappointment extends StatelessWidget {
  const Myappointment({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          backgroundColor: Constants.whitesmoke,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: const Text(
              "My Appointment",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            bottom: const TabBar(
              indicatorWeight: 3,
              indicatorColor: Constants.primcolor,
              isScrollable: true,
              labelColor: Constants.primcolor,
              unselectedLabelColor: Colors.black54,
              tabs: [
                Tab(
                  text: "Upcoming",
                ),
                Tab(
                  text: "Pending",
                ),
                Tab(
                  text: "Completed",
                ),
                Tab(
                  text: "Cancelled",
                )
              ],
            ),
          ),
          body: Get.find<SplashController>().prefs.getString("token") == null
              ? SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child: Center(
                    child: EmojiAlert(
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
                      mainButtonText: const Text("LogIN"),
                      animationType: ANIMATION_TYPE.ROTATION,
                    ),
                  ))
              : TabBarView(
                  children: [
                    // upcomming
                    Query(
                      options: QueryOptions(
                          document: gql(Myquery.upcomming_appointment),
                          variables: {
                            "id":
                                Get.find<SplashController>().prefs.getInt("id")
                          },
                          pollInterval: const Duration(seconds: 5)),
                      builder: (result, {fetchMore, refetch}) {
                        if (result.hasException) {
                          return ListView(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: List.generate(
                                8, (index) => const PendinShimmer()),
                          );
                        }
                        if (result.isLoading) {
                          return ListView(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: List.generate(
                                8, (index) => const upcomming_shimmer()),
                          );
                        }
                        List appointments = result.data!["appointments"];
                        if (appointments.isEmpty) {
                          return no_appointment_found(
                              title: "No upcomming appointment");
                        }

                        return AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: appointments.length,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: GestureDetector(
                                          onTap: () {
                                            Get.toNamed("/myappointmentdetail",
                                                arguments: appointments[index]
                                                    ["id"]);
                                          },
                                          child: AnimatedContainer(
                                              duration:
                                                  const Duration(seconds: 2),
                                              width: Get.width,
                                              height: 130,
                                              margin: const EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 10,
                                              ),
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    10)),
                                                        child: InstaImageViewer(
                                                          backgroundIsTransparent:
                                                              true,
                                                          child:
                                                              CachedNetworkImage(
                                                            width: 70,
                                                            height: 70,
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Icon(Icons
                                                                    .error),
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    const FaIcon(
                                                              FontAwesomeIcons
                                                                  .image,
                                                              color: Constants
                                                                  .primcolor,
                                                            ),
                                                            fit: BoxFit.cover,
                                                            imageUrl: appointments[
                                                                            index]
                                                                        [
                                                                        "doctor"]
                                                                    [
                                                                    "profile_image"]
                                                                ["url"],
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: ListTile(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            title: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                    "Dr. ${appointments[index]["doctor"]["full_name"]}"),
                                                                const SizedBox(
                                                                  height: 7,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      appointments[
                                                                              index]
                                                                          [
                                                                          "package_type"],
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .black54,
                                                                          fontSize:
                                                                              13),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 15,
                                                                    ),
                                                                    Container(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              3),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        color: Colors
                                                                            .green
                                                                            .withOpacity(0.1),
                                                                      ),
                                                                      child:
                                                                          const Text(
                                                                        "Upcomming",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                Colors.green),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const FaIcon(
                                                                      FontAwesomeIcons
                                                                          .calendar,
                                                                      color: Constants
                                                                          .primcolor,
                                                                      size: 12,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 6,
                                                                    ),
                                                                    Text(
                                                                        "${appointments[index]["date"]} / ${appointments[index]["time"]}",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black54,
                                                                            fontSize: 10))
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            trailing: appointments[
                                                                            index]
                                                                        [
                                                                        "package_type"] ==
                                                                    "voice"
                                                                ? Container(
                                                                    width: 40,
                                                                    height: 40,
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(5),
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Constants
                                                                            .primcolor
                                                                            .withOpacity(0.2)),
                                                                    child:
                                                                        const Center(
                                                                      child:
                                                                          FaIcon(
                                                                        FontAwesomeIcons
                                                                            .phone,
                                                                        color: Constants
                                                                            .primcolor,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : appointments[index]
                                                                            [
                                                                            "package_type"] ==
                                                                        "video"
                                                                    ? Container(
                                                                        width:
                                                                            40,
                                                                        height:
                                                                            40,
                                                                        padding:
                                                                            const EdgeInsets.all(5),
                                                                        decoration: BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color: Constants.primcolor.withOpacity(0.2)),
                                                                        child:
                                                                            const Center(
                                                                          child:
                                                                              FaIcon(
                                                                            FontAwesomeIcons.video,
                                                                            color:
                                                                                Constants.primcolor,
                                                                            size:
                                                                                15,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        width:
                                                                            40,
                                                                        height:
                                                                            40,
                                                                        padding:
                                                                            const EdgeInsets.all(5),
                                                                        decoration: BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color: Constants.primcolor.withOpacity(0.2)),
                                                                        child:
                                                                            const Center(
                                                                          child:
                                                                              FaIcon(
                                                                            FontAwesomeIcons.message,
                                                                            color:
                                                                                Constants.primcolor,
                                                                            size:
                                                                                15,
                                                                          ),
                                                                        ),
                                                                      )),
                                                      ),
                                                    ],
                                                  ),
                                                  const Divider(
                                                    thickness: 1,
                                                    color: Colors.black12,
                                                  ),
                                                ],
                                              ))),
                                    ),
                                  ),
                                );
                              },
                            ));
                      },
                    ),
                    //pending
                    Query(
                      options: QueryOptions(
                          document: gql(Myquery.pending_appointment),
                          variables: {
                            "id":
                                Get.find<SplashController>().prefs.getInt("id")
                          },
                          pollInterval: const Duration(seconds: 10)),
                      builder: (result, {fetchMore, refetch}) {
                        if (result.hasException) {
                          return ListView(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: List.generate(
                                8, (index) => const PendinShimmer()),
                          );
                        }
                        if (result.isLoading) {
                          return ListView(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: List.generate(
                                8, (index) => const PendinShimmer()),
                          );
                        }
                        if (result.data!["appointments"].length == 0) {
                          return no_appointment_found(
                              title: "No pending appointment");
                        }
                        return AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: result.data!["appointments"].length,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                        child: AnimatedContainer(
                                            duration:
                                                const Duration(seconds: 2),
                                            width: Get.width,

                                            margin: const EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 10,
                                            ),
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: InstaImageViewer(
                                                        backgroundIsTransparent:
                                                            true,
                                                        child:
                                                            CachedNetworkImage(
                                                          width: 70,
                                                          height: 70,
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                          placeholder:
                                                              (context, url) =>
                                                                  const FaIcon(
                                                            FontAwesomeIcons
                                                                .image,
                                                            color: Constants
                                                                .primcolor,
                                                          ),
                                                          fit: BoxFit.cover,
                                                          imageUrl: result.data![
                                                                      "appointments"]
                                                                  [
                                                                  index]["doctor"]
                                                              [
                                                              "profile_image"]["url"],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: ListTile(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          title: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                  "Dr. ${result.data!["appointments"][index]["doctor"]["full_name"]}"),
                                                              const SizedBox(
                                                                height: 7,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    result.data!["appointments"]
                                                                            [
                                                                            index]
                                                                        [
                                                                        "package_type"],
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black54,
                                                                        fontSize:
                                                                            13),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(3),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: Colors
                                                                          .green
                                                                          .withOpacity(
                                                                              0.1),
                                                                    ),
                                                                    child:
                                                                        const Text(
                                                                      "Pending",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              Colors.green),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  const FaIcon(
                                                                    FontAwesomeIcons
                                                                        .calendar,
                                                                    color: Constants
                                                                        .primcolor,
                                                                    size: 12,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 6,
                                                                  ),
                                                                  Flexible(
                                                                    child: Text(
                                                                        "${result.data!["appointments"][index]["date"]} / ${result.data!["appointments"][index]["time"]}",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black54,
                                                                            fontSize: 13)),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          trailing: result.data![
                                                                              "appointments"]
                                                                          [index]
                                                                      [
                                                                      "package_type"] ==
                                                                  "voice"
                                                              ? Container(
                                                                  width: 40,
                                                                  height: 40,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(5),
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Constants
                                                                          .primcolor
                                                                          .withOpacity(
                                                                              0.2)),
                                                                  child:
                                                                      const Center(
                                                                    child:
                                                                        FaIcon(
                                                                      FontAwesomeIcons
                                                                          .phone,
                                                                      color: Constants
                                                                          .primcolor,
                                                                      size: 15,
                                                                    ),
                                                                  ),
                                                                )
                                                              : result.data!["appointments"]
                                                                              [index]
                                                                          ["package_type"] ==
                                                                      "video"
                                                                  ? Container(
                                                                      width: 40,
                                                                      height:
                                                                          40,
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              5),
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          color: Constants
                                                                              .primcolor
                                                                              .withOpacity(0.2)),
                                                                      child:
                                                                          const Center(
                                                                        child:
                                                                            FaIcon(
                                                                          FontAwesomeIcons
                                                                              .video,
                                                                          color:
                                                                              Constants.primcolor,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      width: 40,
                                                                      height:
                                                                          40,
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              5),
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          color: Constants
                                                                              .primcolor
                                                                              .withOpacity(0.2)),
                                                                      child:
                                                                          const Center(
                                                                        child:
                                                                            FaIcon(
                                                                          FontAwesomeIcons
                                                                              .message,
                                                                          color:
                                                                              Constants.primcolor,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                      ),
                                                                    )),
                                                    ),
                                                  ],
                                                ),
                                                const Divider(
                                                  thickness: 1,
                                                  color: Colors.black12,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Expanded(
                                                        flex: 1,
                                                        child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                elevation: 0,
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                side: const BorderSide(
                                                                    color: Constants
                                                                        .primcolor)),
                                                            onPressed: () {
                                                              Get.bottomSheet(
                                                                  ClipRRect(
                                                                borderRadius: const BorderRadius
                                                                        .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            20),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            20)),
                                                                child:
                                                                    BottomSheet(
                                                                  onClosing:
                                                                      () {},
                                                                  builder:
                                                                      (context) {
                                                                    return Container(
                                                                      width: Get
                                                                          .width,
                                                                      height:
                                                                          Get.height /
                                                                              2.5,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Row(
                                                                            children: const [
                                                                              Spacer(),
                                                                              Expanded(
                                                                                  child: Divider(
                                                                                thickness: 1,
                                                                                color: Colors.black54,
                                                                              )),
                                                                              Spacer()
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          const Text(
                                                                            "cancel appointment",
                                                                            style:
                                                                                TextStyle(fontSize: 25, color: Colors.red),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          Row(
                                                                            children: const [
                                                                              Expanded(
                                                                                  child: Divider(
                                                                                thickness: 1,
                                                                                color: Colors.black12,
                                                                              )),
                                                                            ],
                                                                          ),
                                                                          const Text(
                                                                            "Are you sure you want to cancel your appointment?",
                                                                            style:
                                                                                TextStyle(fontSize: 17),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          const Text(
                                                                            "only 70% of the funds will be returned to your account",
                                                                            style:
                                                                                TextStyle(fontSize: 14),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                25,
                                                                          ),
                                                                          Mutation(
                                                                            options:
                                                                                MutationOptions(
                                                                              document: gql(Mymutation.refund_request),
                                                                              onCompleted: (data) {
                                                                                Get.find<MyappointmentController>().is_cancel_appoint.value = false;
                                                                                Get.find<NotificationController>().crateNotification("Appointment cancelled", "your appointment was cancelled  please you can make any other appointment");
                                                                                Get.back();
                                                                              },
                                                                            ),
                                                                            builder:
                                                                                (runMutation, resultte) {
                                                                              return Mutation(
                                                                                options: MutationOptions(
                                                                                  document: gql(Mymutation.insert_notification_doc),
                                                                                  onCompleted: (data) {
                                                                                    Get.find<MyappointmentController>().is_cancel_appoint.value = true;
                                                                                    runMutation({
                                                                                      "id": result.data!["appointments"][index]["id"]
                                                                                    });
                                                                                  },
                                                                                ),
                                                                                builder: (runMutation, resulte) {
                                                                                  if (resulte!.hasException) {
                                                                                    print(resulte.exception.toString());
                                                                                  }
                                                                                  return Mutation(
                                                                                    options: MutationOptions(
                                                                                      document: gql(Mymutation.update_appo_statuss),
                                                                                      onCompleted: (data) {
                                                                                        Get.find<MyappointmentController>().is_cancel_appoint.value = true;
                                                                                        runMutation({
                                                                                          "title": "Appointment Cancelled",
                                                                                          "description": "your appointment on ${result.data!["appointments"][index]["date"]}was cancelled ",
                                                                                          "type": "Cancelled",
                                                                                          "doctor_id": result.data!["appointments"][index]["doctor"]["id"]
                                                                                        });
                                                                                      },
                                                                                    ),
                                                                                    builder: (runMutation, resultt) {
                                                                                      if (result.isLoading) {
                                                                                        Get.find<MyappointmentController>().is_cancel_appoint.value = true;
                                                                                      }
                                                                                      return Container(
                                                                                          width: Get.width,
                                                                                          margin: const EdgeInsets.all(20),
                                                                                          child: Obx(() => ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(30),
                                                                                              child: ElevatedButton(
                                                                                                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
                                                                                                  onPressed: () {
                                                                                                    runMutation({
                                                                                                      "id": result.data!["appointments"][index]["id"],
                                                                                                      "status": "cancelled"
                                                                                                    });
                                                                                                    // run mutation
                                                                                                  },
                                                                                                  child: Get.find<MyappointmentController>().is_cancel_appoint.value
                                                                                                      ? Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                          children: const [
                                                                                                            ButtonSpinner(),
                                                                                                            SizedBox(
                                                                                                              width: 10,
                                                                                                            ),
                                                                                                            Text("please wait...")
                                                                                                          ],
                                                                                                        )
                                                                                                      : const Text("Yes Cancel")))));
                                                                                    },
                                                                                  );
                                                                                },
                                                                              );
                                                                            },
                                                                          )
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ));
                                                            },
                                                            child: const Text(
                                                              "Cancel appointment",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black),
                                                            ))),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                        flex: 1,
                                                        child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              elevation: 0,
                                                            ),
                                                            onPressed: () {
                                                              Get.toNamed(
                                                                  "/reschedule",
                                                                  arguments: result
                                                                              .data![
                                                                          "appointments"]
                                                                      [
                                                                      0]["id"]);
                                                            },
                                                            child: const Text(
                                                                "Reschedule ",
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                    fontSize:
                                                                        12))))
                                                  ],
                                                )
                                              ],
                                            ))),
                                  ),
                                );
                              },
                            ));
                      },
                    ),
                    //complated
                    Query(
                      options: QueryOptions(
                          document: gql(Myquery.complated_appointment),
                          variables: {
                            "id":
                                Get.find<SplashController>().prefs.getInt("id")
                          },
                          pollInterval: const Duration(seconds: 10)),
                      builder: (result, {fetchMore, refetch}) {
                        if (result.hasException) {
                          return ListView(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: List.generate(
                                8, (index) => const PendinShimmer()),
                          );
                        }
                        if (result.isLoading) {
                          return ListView(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: List.generate(
                                8, (index) => const PendinShimmer()),
                          );
                        }
                        if (result.data!["appointments"].length == 0) {
                          return no_appointment_found(
                            title: "No complated appointment",
                          );
                        }
                        return AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: result.data!["appointments"].length,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                        child: AnimatedContainer(
                                            duration:
                                                const Duration(seconds: 2),
                                            width: Get.width,
                                            height: 110,
                                            margin: const EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 10,
                                            ),
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: InstaImageViewer(
                                                        backgroundIsTransparent:
                                                            true,
                                                        child:
                                                            CachedNetworkImage(
                                                          width: 70,
                                                          height: 70,
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                          placeholder:
                                                              (context, url) =>
                                                                  const FaIcon(
                                                            FontAwesomeIcons
                                                                .image,
                                                            color: Constants
                                                                .primcolor,
                                                          ),
                                                          fit: BoxFit.cover,
                                                          imageUrl: result.data![
                                                                      "appointments"]
                                                                  [
                                                                  index]["doctor"]
                                                              [
                                                              "profile_image"]["url"],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: ListTile(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          title: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                  "Dr. ${result.data!["appointments"][index]["doctor"]["full_name"]}"),
                                                              const SizedBox(
                                                                height: 7,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    result.data!["appointments"]
                                                                            [
                                                                            index]
                                                                        [
                                                                        "package_type"],
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black54,
                                                                        fontSize:
                                                                            13),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(3),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: Colors
                                                                          .green
                                                                          .withOpacity(
                                                                              0.1),
                                                                    ),
                                                                    child:
                                                                        const Text(
                                                                      "Completed",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              Colors.green),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  const FaIcon(
                                                                    FontAwesomeIcons
                                                                        .calendar,
                                                                    color: Constants
                                                                        .primcolor,
                                                                    size: 12,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 6,
                                                                  ),
                                                                  Flexible(
                                                                    child: Text(
                                                                        "${result.data!["appointments"][index]["date"]} / ${result.data!["appointments"][index]["time"]}",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black54,
                                                                            fontSize: 13)),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          trailing: result.data![
                                                                              "appointments"]
                                                                          [index]
                                                                      [
                                                                      "package_type"] ==
                                                                  "voice"
                                                              ? Container(
                                                                  width: 40,
                                                                  height: 40,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(5),
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Constants
                                                                          .primcolor
                                                                          .withOpacity(
                                                                              0.2)),
                                                                  child:
                                                                      const Center(
                                                                    child:
                                                                        FaIcon(
                                                                      FontAwesomeIcons
                                                                          .phone,
                                                                      color: Constants
                                                                          .primcolor,
                                                                      size: 15,
                                                                    ),
                                                                  ),
                                                                )
                                                              : result.data!["appointments"]
                                                                              [index]
                                                                          ["package_type"] ==
                                                                      "video"
                                                                  ? Container(
                                                                      width: 40,
                                                                      height:
                                                                          40,
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              5),
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          color: Constants
                                                                              .primcolor
                                                                              .withOpacity(0.2)),
                                                                      child:
                                                                          const Center(
                                                                        child:
                                                                            FaIcon(
                                                                          FontAwesomeIcons
                                                                              .video,
                                                                          color:
                                                                              Constants.primcolor,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      width: 40,
                                                                      height:
                                                                          40,
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              5),
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          color: Constants
                                                                              .primcolor
                                                                              .withOpacity(0.2)),
                                                                      child:
                                                                          const Center(
                                                                        child:
                                                                            FaIcon(
                                                                          FontAwesomeIcons
                                                                              .message,
                                                                          color:
                                                                              Constants.primcolor,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                      ),
                                                                    )),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ))),
                                  ),
                                );
                              },
                            ));
                      },
                    ),
                    //canceled
                    Query(
                      options: QueryOptions(
                          document: gql(Myquery.cancelled_appointment),
                          variables: {
                            "id":
                                Get.find<SplashController>().prefs.getInt("id")
                          },
                          pollInterval: const Duration(seconds: 10)),
                      builder: (result, {fetchMore, refetch}) {
                        if (result.hasException) {
                          return ListView(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: List.generate(
                                8, (index) => const PendinShimmer()),
                          );
                        }
                        if (result.isLoading) {
                          return ListView(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: List.generate(
                                8, (index) => const PendinShimmer()),
                          );
                        }
                        if (result.data!["appointments"].length == 0) {
                          return no_appointment_found(
                            title: "No cancelled appointment",
                          );
                        }
                        return AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: result.data!["appointments"].length,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: AnimatedContainer(
                                          duration: const Duration(seconds: 2),
                                          width: Get.width,
                                          margin: const EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 10,
                                          ),
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    child: InstaImageViewer(
                                                      backgroundIsTransparent:
                                                          true,
                                                      child: CachedNetworkImage(
                                                        width: 60,
                                                        height: 60,
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                        placeholder:
                                                            (context, url) =>
                                                                const FaIcon(
                                                          FontAwesomeIcons
                                                              .image,
                                                          color: Constants
                                                              .primcolor,
                                                        ),
                                                        fit: BoxFit.cover,
                                                        imageUrl: result.data![
                                                                    "appointments"]
                                                                [
                                                                index]["doctor"]
                                                            [
                                                            "profile_image"]["url"],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: ListTile(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        title: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                "Dr. ${result.data!["appointments"][index]["doctor"]["full_name"]}"),
                                                            const SizedBox(
                                                              height: 7,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  result.data![
                                                                              "appointments"]
                                                                          [
                                                                          index]
                                                                      [
                                                                      "package_type"],
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                          13),
                                                                ),
                                                                const SizedBox(
                                                                  width: 15,
                                                                ),
                                                                Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(3),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    color: Colors
                                                                        .red
                                                                        .withOpacity(
                                                                            0.1),
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    "Cancelled",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                const FaIcon(
                                                                  FontAwesomeIcons
                                                                      .calendar,
                                                                  color: Constants
                                                                      .primcolor,
                                                                  size: 12,
                                                                ),
                                                                const SizedBox(
                                                                  width: 6,
                                                                ),
                                                                Flexible(
                                                                  child: Text(
                                                                      "${result.data!["appointments"][index]["date"]} / ${result.data!["appointments"][index]["time"]}",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .black54,
                                                                          fontSize:
                                                                              13)),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        trailing: result.data![
                                                                            "appointments"]
                                                                        [index][
                                                                    "package_type"] ==
                                                                "voice"
                                                            ? Container(
                                                                width: 40,
                                                                height: 40,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Constants
                                                                        .primcolor
                                                                        .withOpacity(
                                                                            0.2)),
                                                                child:
                                                                    const Center(
                                                                  child: FaIcon(
                                                                    FontAwesomeIcons
                                                                        .phone,
                                                                    color: Constants
                                                                        .primcolor,
                                                                    size: 15,
                                                                  ),
                                                                ),
                                                              )
                                                            : result.data!["appointments"]
                                                                            [index]
                                                                        [
                                                                        "package_type"] ==
                                                                    "video"
                                                                ? Container(
                                                                    width: 40,
                                                                    height: 40,
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(5),
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Constants
                                                                            .primcolor
                                                                            .withOpacity(0.2)),
                                                                    child:
                                                                        const Center(
                                                                      child:
                                                                          FaIcon(
                                                                        FontAwesomeIcons
                                                                            .video,
                                                                        color: Constants
                                                                            .primcolor,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    width: 40,
                                                                    height: 40,
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(5),
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Constants
                                                                            .primcolor
                                                                            .withOpacity(0.2)),
                                                                    child:
                                                                        const Center(
                                                                      child:
                                                                          FaIcon(
                                                                        FontAwesomeIcons
                                                                            .message,
                                                                        color: Constants
                                                                            .primcolor,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                  )),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                );
                              },
                            ));
                      },
                    ),
                  ],
                )),
    );
  }
}
