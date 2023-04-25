import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/screens/user/user/doctor_detail/widget/doctorshimer.dart';
import 'package:hakimea/screens/user/user/doctor_detail/widget/specialityshimer.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

import '../../../../apiservice/myquery.dart';
import '../../../../controllers/user_controllers/doctorprofilecontroller.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/no_doc_found.dart';

class Doctor extends StatelessWidget {
  const Doctor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.primcolor,
        actions: [
          IconButton(
              onPressed: () => Get.toNamed("/docsearch"),
              icon: const FaIcon(
                FontAwesomeIcons.search,
                size: 18,
                color: Constants.whitesmoke,
              ))
        ],
        title: const Text(
          "Doctors",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Colors.white,
            )),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Get.width,
            height: 120,
            decoration: const BoxDecoration(
                color: Constants.primcolor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Speciality",
                    style: TextStyle(color: Constants.whitesmoke),
                  ),
                ),
                //speciality
                const SizedBox(
                  height: 3,
                ),
                Query(
                  options: QueryOptions(
                    document: gql(Myquery.allspeciality),
                  ),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.isLoading) {
                      return Container(
                        width: Get.width,
                        height: 50,
                        margin: const EdgeInsets.only(left: 10),
                        child: ListView.builder(
                          itemCount: 6,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return const SpecialityShimmer();
                          },
                        ),
                      );
                    }
                    List? Speciality = result.data!["speciallities"];
                    if (Speciality!.isEmpty) {
                      return const Text("no speciality found");
                    }
                    Speciality.insert(
                      0,
                      {"id": 0, "speciallity_name": "All"},
                    );

                    return Container(
                      width: Get.width,
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      height: 50,
                      child: ListView.builder(
                        itemCount: Speciality.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Obx(() => GestureDetector(
                                onTap: () {
                                  Get.find<DoctorProfileController>()
                                      .current_speciality
                                      .value = index;
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  width: 100,
                                  height: 25,
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: index ==
                                            Get.find<DoctorProfileController>()
                                                .current_speciality
                                                .value
                                        ? Constants.whitesmoke
                                        : Constants.whitesmoke.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Flexible(
                                    child: Center(
                                        child: Text(
                                      Speciality[index]["speciallity_name"],
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: index ==
                                                  Get.find<
                                                          DoctorProfileController>()
                                                      .current_speciality
                                                      .value
                                              ? Constants.primcolor
                                              : Constants.whitesmoke
                                                  .withOpacity(0.3)),
                                    )),
                                  ),
                                ),
                              ));
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 10,
          ),
          Container(
            width: Get.width,
            height: 50,
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Text(
                      "${Get.find<DoctorProfileController>().num_of_doctors.value} Found"),
                ),
                Row(
                  children: const [
                    Text(
                      "default",
                      style: TextStyle(color: Constants.primcolor),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    FaIcon(
                      FontAwesomeIcons.arrowsRotate,
                      size: 13,
                      color: Constants.primcolor,
                    )
                  ],
                )
              ],
            ),
          ),

          // doctor list
          Expanded(
            child: Obx(() => Query(
                  options: Get.find<DoctorProfileController>()
                          .current_speciality
                          .value
                          .isEqual(0)
                      ? QueryOptions(
                          document: gql(Myquery.alldoctor),
                          onComplete: (data) {
                            if (data.isNotEmpty) {
                              Get.find<DoctorProfileController>()
                                  .num_of_doctors
                                  .value = data["doctors"].length;
                            }
                          },
                        )
                      : QueryOptions(
                          document: gql(Myquery.specialitydoctor),
                          variables: {
                            "speciallity": Get.find<DoctorProfileController>()
                                .current_speciality
                                .value
                          },
                          onComplete: (data) {
                            if (data.isNotEmpty) {
                              Get.find<DoctorProfileController>()
                                  .num_of_doctors
                                  .value = data["doctors"].length;
                            }
                          },
                        ),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.hasException) {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => const doctor_shimmer(),
                      );
                    }
                    if (result.isLoading) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => const doctor_shimmer(),
                      );
                    }
                    List? doctors = result.data?["doctors"];
                    if (doctors!.isEmpty) {
                      return const No_doc_found();
                    } else {
                      return AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: doctors.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 200),
                                child: GestureDetector(
                                  onTap: () => Get.toNamed("/doctorprofile",
                                      arguments: doctors[index]["id"]),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: AnimatedContainer(
                                        duration: const Duration(seconds: 2),
                                        padding: const EdgeInsets.only(
                                          right: 10,
                                        ),
                                        width: Get.width,
                                        height: 130,
                                        margin: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                bottomLeft: Radius.circular(15),
                                              ),
                                              child: InstaImageViewer(
                                                child: CachedNetworkImage(
                                                  imageUrl: doctors[index]
                                                              ["profile_image"]
                                                          ["url"]
                                                      .toString(),
                                                  width: 100,
                                                  height: 130,
                                                  placeholder: (context, url) =>
                                                      const Icon(Icons.image),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              //mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    const Text(
                                                      "Dr ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                    Text(
                                                      doctors[index]
                                                          ["full_name"],
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    doctors[index]["is_online"]
                                                        ? Icon(
                                                            Icons
                                                                .circle_rounded,
                                                            color: Constants
                                                                .primcolor
                                                                .withOpacity(
                                                                    0.7),
                                                            size: 12,
                                                          )
                                                        : const Text(""),
                                                  ],
                                                ),
                                                Text(
                                                  doctors[index]
                                                          ["speciallities"]
                                                      ["speciallity_name"],
                                                  style: const TextStyle(
                                                      color: Colors.black54),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    RatingBar.builder(
                                                      initialRating:
                                                          double.parse(
                                                              doctors[index]
                                                                      ["rate"]
                                                                  .toString()),
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize: 11,
                                                      itemPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 1.0),
                                                      itemBuilder:
                                                          (context, _) =>
                                                              const Icon(
                                                        Icons.star,
                                                        color:
                                                            Constants.primcolor,
                                                      ),
                                                      onRatingUpdate:
                                                          (rating) {},
                                                    ),
                                                    Text("(0 people)")
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    const FaIcon(
                                                      FontAwesomeIcons.hospital,
                                                      color: Colors.black54,
                                                      size: 14,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      doctors[index]
                                                          ["current_hospital"],
                                                      style: const TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Colors.black54),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                  },
                )),
          ),
        ],
      ),
    );
  }
}
