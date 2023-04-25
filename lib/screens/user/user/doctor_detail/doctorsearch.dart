import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/myquery.dart';
import 'package:hakimea/controllers/user_controllers/signupcontroller.dart';
import 'package:hakimea/widgets/cool_loading.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

import '../../../../controllers/user_controllers/doctorprofilecontroller.dart';
import '../../../../utils/constants.dart';

class DoctorSearch extends StatelessWidget {
  DoctorSearch({super.key});

  TextEditingController _filter = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.primcolor,
        elevation: 0,
        title: const Text(
          "Search Doctors",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Colors.white,
            )),
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
                color: Constants.primcolor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: TextFormField(
              controller: _filter,
              keyboardType: TextInputType.text,
              enabled: true,
              autofocus: true,
              onChanged: (newValue) {
                Get.find<DoctorProfileController>().doc_filter_search.value =
                    newValue.toString();
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return null;
                } else if (value.contains(RegExp(r'[1-9]'))) {
                  return Get.find<SignUpController>()
                      .customsnack("enter valid search key");
                }
                return null;
              },
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15),
                  hintText: "search",
                  filled: true,
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 17,
                    color: Constants.primcolor,
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const FaIcon(
                        FontAwesomeIcons.microphone,
                        color: Constants.primcolor,
                      )),
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Constants.whitesmoke),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  disabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Constants.whitesmoke),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Constants.whitesmoke),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Constants.whitesmoke),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  fillColor: Colors.white),
            ),
          ),
          Container(
            width: Get.width,
            height: 50,
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Get.find<DoctorProfileController>()
                              .doc_filter_search
                              .value ==
                          ""
                      ? const Text("0 Found",
                          style: TextStyle(color: Constants.primcolor))
                      : Text(
                          "${Get.find<DoctorProfileController>().num_of_doctors_filterd.value} Found",
                          style: const TextStyle(color: Constants.primcolor)),
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
          Obx(() => Query(
                options: QueryOptions(
                  document: gql(Myquery.search_doc),
                  variables: {
                    "filter":
                        "%${Get.find<DoctorProfileController>().doc_filter_search.value}%"
                  },
                  onComplete: (data) {
                    Get.find<DoctorProfileController>()
                        .num_of_doctors_filterd
                        .value = data["doctors"].length;
                  },
                ),
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
                  List? doctors = result.data!["doctors"];
                  if (doctors!.isEmpty) {
                    return SizedBox(
                      width: Get.width,
                      height: 100,
                      child: const Center(
                        child: Text("No doctor found"),
                      ),
                    );
                  }
                  return Get.find<DoctorProfileController>()
                              .doc_filter_search
                              .value ==
                          ""
                      ? Container()
                      : Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: doctors.length,
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
                                            duration:
                                                const Duration(seconds: 2),
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
                                                    topLeft:
                                                        Radius.circular(15),
                                                    bottomLeft:
                                                        Radius.circular(15),
                                                  ),
                                                  child: InstaImageViewer(
                                                    child: CachedNetworkImage(
                                                      imageUrl: doctors[index][
                                                                  "profile_image"]
                                                              ["url"]
                                                          .toString(),
                                                      width: 100,
                                                      height: 130,
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
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                          doctors[index]
                                                              ["full_name"],
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        doctors[index]
                                                                ["is_online"]
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
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        RatingBar.builder(
                                                          initialRating: double
                                                              .parse(doctors[
                                                                          index]
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
                                                                  horizontal:
                                                                      1.0),
                                                          itemBuilder:
                                                              (context, _) =>
                                                                  const Icon(
                                                            Icons.star,
                                                            color: Constants
                                                                .primcolor,
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
                                                          FontAwesomeIcons
                                                              .hospital,
                                                          color: Colors.black54,
                                                          size: 14,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          doctors[index][
                                                              "current_hospital"],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black54),
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
                          ),
                        );
                },
              ))
        ],
      ),
    );
  }
}
