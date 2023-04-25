import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/mymutation.dart';
import 'package:hakimea/apiservice/myquery.dart';
import 'package:hakimea/controllers/splashcontroller.dart';
import 'package:hakimea/controllers/user_controllers/myappointmentcontroller.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:hakimea/widgets/buttonspinner.dart';
import 'package:hakimea/widgets/loading.dart';

class SubmitReview extends StatelessWidget {
  SubmitReview({Key? key}) : super(key: key);

  TextEditingController Reviewcontrollers = TextEditingController();
  customsnack(String message) {
    return Get.snackbar("Error", message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        maxWidth: Get.width,
        snackStyle: SnackStyle.GROUNDED,
        margin: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
        padding: const EdgeInsets.all(10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.whitesmoke,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Write a review",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Query(
          options: QueryOptions(document: gql(Myquery.doc_profile), variables: {
            "id": Get.find<MyappointmentController>().reviewed_doctor.value
          }),
          builder: (result, {fetchMore, refetch}) {
            if (result.isLoading) {
              return const Center(
                child: loading(),
              );
            }
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: Get.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            width: 150,
                            height: 150,
                            placeholder: (context, url) => const Center(
                              child: FaIcon(
                                FontAwesomeIcons.image,
                                color: Constants.primcolor,
                              ),
                            ),
                            fit: BoxFit.cover,
                            imageUrl: result.data!["doctors_by_pk"]
                                ["profile_image"]["url"],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "How was your experiance with Dr.${result.data!["doctors_by_pk"]["full_name"]}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Give rate to Dr.${result.data!["doctors_by_pk"]["full_name"]}",
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(() => RatingBar.builder(
                        initialRating:
                            Get.find<MyappointmentController>().rate.value,
                        minRating: 1,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemSize: 30,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          Get.find<MyappointmentController>().rate.value =
                              rating;
                        },
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Write your review",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: Reviewcontrollers,
                      maxLines: 5,
                      decoration: const InputDecoration(
                          hintText: "write review hear......",
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          fillColor: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Mutation(
                    options: MutationOptions(
                      document: gql(Mymutation.review),
                      onCompleted: (data) {
                        Get.find<MyappointmentController>().is_review.value =
                            false;
                        if (data != null && data.isNotEmpty) {
                          Get.offAllNamed("/mainhomepage");
                        }
                      },
                    ),
                    builder: (runMutation, result) {
                      if (result!.isLoading) {
                        Get.find<MyappointmentController>().is_review.value =
                            true;
                      }
                      return Container(
                          width: Get.width,
                          margin: const EdgeInsets.only(left: 15, right: 15),
                          child: Obx(() => ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        padding: const EdgeInsets.all(15)),
                                    onPressed: () {
                                      if (Reviewcontrollers.text.isEmpty) {
                                        customsnack("please write review");
                                      } else if (Get.find<
                                                  MyappointmentController>()
                                              .rate
                                              .value ==
                                          0.0) {
                                        customsnack("please give rate");
                                      } else {
                                        runMutation({
                                          "rate": Get.find<
                                                  MyappointmentController>()
                                              .rate
                                              .value
                                              .toInt(),
                                          "user_id":
                                              Get.find<SplashController>()
                                                  .prefs
                                                  .getInt("id"),
                                          "doctor_id": Get.find<
                                                  MyappointmentController>()
                                              .reviewed_doctor
                                              .value,
                                          "review": Reviewcontrollers.text,
                                        });
                                      }
                                    },
                                    child: Get.find<MyappointmentController>()
                                            .is_review
                                            .value
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              ButtonSpinner(),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text("please wait..")
                                            ],
                                          )
                                        : const Text(
                                            "Submit Review",
                                          )),
                              )));
                    },
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  Container(
                      width: Get.width,
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.all(15)),
                            onPressed: () {
                              Get.offAllNamed("/mainhomepage");
                            },
                            child: const Text(
                              "Go to Homepage",
                              style: TextStyle(color: Constants.primcolor),
                            )),
                      ))
                ],
              ),
            );
          },
        ));
  }
}
