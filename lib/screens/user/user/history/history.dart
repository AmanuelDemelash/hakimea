import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_alert/arrays.dart';
import 'package:emoji_alert/emoji_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/myquery.dart';
import 'package:hakimea/controllers/splashcontroller.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:hakimea/widgets/cool_loading.dart';

import '../../../../widgets/loginalert.dart';

class History extends StatelessWidget {
  const History({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: Constants.whitesmoke,
          appBar: AppBar(
            backgroundColor: Constants.whitesmoke,
            automaticallyImplyLeading: false,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const FaIcon(
                  FontAwesomeIcons.angleLeft,
                  color: Colors.black,
                )),
            title: const Text(
              "History",
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
                  text: "Messages",
                ),
                Tab(
                  text: "Voice call",
                ),
                Tab(
                  text: "Video call",
                ),
              ],
            ),
          ),
          body: Get.find<SplashController>().prefs.getString("token") == null
              ? loginalert()
              : TabBarView(children: [
                  // message
                  const Center(
                      child: Text(
                    "no chat history",
                    style: TextStyle(color: Colors.black54),
                  )),
                  // SingleChildScrollView(
                  //   physics: const BouncingScrollPhysics(),
                  //   child: AnimatedContainer(
                  //       duration: const Duration(seconds: 1),
                  //       height: Get.height,
                  //       width: Get.width,
                  //       child: Center(child: Text("no chat history"))
                  //       //  ListView(
                  //       //     physics: const NeverScrollableScrollPhysics(),
                  //       //     shrinkWrap: true,
                  //       //     children: List.generate(
                  //       //       10,
                  //       //       (index) => AnimationConfiguration.staggeredList(
                  //       //         position: index,
                  //       //         duration: const Duration(milliseconds: 375),
                  //       //         child: SlideAnimation(
                  //       //           verticalOffset: 50.0,
                  //       //           child: FadeInAnimation(
                  //       //             child: GestureDetector(
                  //       //                 child: Container(
                  //       //               margin: const EdgeInsets.only(
                  //       //                   left: 10, right: 10, bottom: 10),
                  //       //               decoration: BoxDecoration(
                  //       //                   color: Colors.white,
                  //       //                   borderRadius:
                  //       //                       BorderRadius.circular(10)),
                  //       //               child: ListTile(
                  //       //                 onTap: () => Get.toNamed("/chatdetail"),
                  //       //                 contentPadding: const EdgeInsets.all(5),
                  //       //                 leading: const CircleAvatar(
                  //       //                   radius: 40,
                  //       //                   backgroundImage: NetworkImage(
                  //       //                       "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80"),
                  //       //                 ),
                  //       //                 title: const Text("Dr. amanuel demelash"),
                  //       //                 subtitle: const Text(
                  //       //                     "my pressure all the best for.."),
                  //       //                 trailing: Column(
                  //       //                   children: const [
                  //       //                     Text(
                  //       //                       "today",
                  //       //                       style: TextStyle(
                  //       //                           color: Colors.black54),
                  //       //                     ),
                  //       //                     Text(
                  //       //                       "10:23am",
                  //       //                       style: TextStyle(
                  //       //                           color: Colors.black54),
                  //       //                     )
                  //       //                   ],
                  //       //                 ),
                  //       //               ),
                  //       //             )),
                  //       //           ),
                  //       //         ),
                  //       //       ),
                  //       //     )),
                  //       ),
                  // ),
                  // voice
                  Query(
                    options: QueryOptions(
                        document: gql(Myquery.voice_history),
                        variables: {
                          "id": Get.find<SplashController>().prefs.getInt("id")
                        }),
                    builder: (result, {fetchMore, refetch}) {
                      if (result.hasException) {
                        return const Center(
                          child: cool_loding(),
                        );
                      }
                      if (result.isLoading) {
                        return const Center(
                          child: cool_loding(),
                        );
                      }
                      List? videohis = result.data!["appointments"];
                      if (videohis!.isEmpty) {
                        return const Center(
                          child: Text(
                            "no history found",
                            style: TextStyle(color: Colors.black54),
                          ),
                        );
                      }
                      return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: AnimatedContainer(
                              duration: const Duration(seconds: 1),
                              height: Get.height,
                              width: Get.width,
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: videohis.length,
                                itemBuilder: (context, index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: GestureDetector(
                                            onTap: () => Get.toNamed(
                                                    "/voicehistory",
                                                    arguments: {
                                                      "image": videohis[index]
                                                                  ["doctor"]
                                                              ["profile_image"]
                                                          ["url"],
                                                      "name": videohis[index]
                                                              ["doctor"]
                                                          ["full_name"],
                                                      "date": videohis[index]
                                                          ["date"]
                                                    }),
                                            child: Container(
                                              height: 80,
                                              width: Get.width,
                                              margin: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    child: CachedNetworkImage(
                                                      imageUrl: videohis[index]
                                                                  ["doctor"]
                                                              ["profile_image"]
                                                          ["url"],
                                                      width: 75,
                                                      height: 75,
                                                      placeholder: (context,
                                                              url) =>
                                                          const Icon(
                                                              Icons.image),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: ListTile(
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    title: Text(
                                                        "Dr.${videohis[index]["doctor"]["full_name"]}"),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: const [
                                                            Text(
                                                              "Voice call",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 13),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            FaIcon(
                                                              FontAwesomeIcons
                                                                  .microphone,
                                                              size: 11,
                                                              color: Constants
                                                                  .primcolor,
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          videohis[index]
                                                              ["date"],
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 13),
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: Container(
                                                        width: 30,
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Constants
                                                                    .primcolor
                                                                    .withOpacity(
                                                                        0.3)),
                                                        child: const Center(
                                                            child: FaIcon(
                                                          FontAwesomeIcons
                                                              .angleRight,
                                                          color: Constants
                                                              .primcolor,
                                                          size: 15,
                                                        ))),
                                                  ))
                                                ],
                                              ),
                                            )),
                                      ),
                                    ),
                                  );
                                },
                              )));
                    },
                  ),
                  // video

                  Query(
                    options: QueryOptions(
                        document: gql(Myquery.video_history),
                        variables: {
                          "id": Get.find<SplashController>().prefs.getInt("id")
                        }),
                    builder: (result, {fetchMore, refetch}) {
                      if (result.hasException) {
                        return const Center(
                          child: cool_loding(),
                        );
                      }
                      if (result.isLoading) {
                        return const Center(
                          child: cool_loding(),
                        );
                      }
                      List? videohis = result.data!["appointments"];
                      if (videohis!.isEmpty) {
                        return const Center(
                          child: Text(
                            "no history found",
                            style: TextStyle(color: Colors.black54),
                          ),
                        );
                      }
                      return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: AnimatedContainer(
                              duration: const Duration(seconds: 1),
                              height: Get.height,
                              width: Get.width,
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: videohis.length,
                                itemBuilder: (context, index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: GestureDetector(
                                            onTap: () => Get.toNamed(
                                                    "/videohistory",
                                                    arguments: {
                                                      "image": videohis[index]
                                                                  ["doctor"]
                                                              ["profile_image"]
                                                          ["url"],
                                                      "name": videohis[index]
                                                              ["doctor"]
                                                          ["full_name"],
                                                      "date": videohis[index]
                                                          ["date"]
                                                    }),
                                            child: Container(
                                              height: 80,
                                              width: Get.width,
                                              margin: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    child: CachedNetworkImage(
                                                      imageUrl: videohis[index]
                                                                  ["doctor"]
                                                              ["profile_image"]
                                                          ["url"],
                                                      width: 75,
                                                      height: 75,
                                                      placeholder: (context,
                                                              url) =>
                                                          const Icon(
                                                              Icons.image),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: ListTile(
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    title: Text(
                                                        "Dr.${videohis[index]["doctor"]["full_name"]}"),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: const [
                                                            Text(
                                                              "Video call",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 13),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            FaIcon(
                                                              FontAwesomeIcons
                                                                  .video,
                                                              size: 11,
                                                              color: Constants
                                                                  .primcolor,
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          videohis[index]
                                                              ["date"],
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 13),
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: Container(
                                                        width: 30,
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Constants
                                                                    .primcolor
                                                                    .withOpacity(
                                                                        0.3)),
                                                        child: const Center(
                                                            child: FaIcon(
                                                          FontAwesomeIcons
                                                              .angleRight,
                                                          color: Constants
                                                              .primcolor,
                                                          size: 15,
                                                        ))),
                                                  ))
                                                ],
                                              ),
                                            )),
                                      ),
                                    ),
                                  );
                                },
                              )));
                    },
                  ),
                ])),
    );
  }
}
