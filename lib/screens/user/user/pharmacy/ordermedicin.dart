import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/mymutation.dart';
import 'package:hakimea/controllers/locationcontrollers.dart';
import 'package:hakimea/controllers/splashcontroller.dart';
import 'package:hakimea/controllers/user_controllers/ordermedicincontroller.dart';
import 'package:hakimea/controllers/user_controllers/signupcontroller.dart';
import 'package:hakimea/widgets/buttonspinner.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

import '../../../../utils/constants.dart';
import '../../../../widgets/cool_loading.dart';

class Order_medicin extends StatelessWidget {
  Map pharmacy = Get.arguments;

  Order_medicin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Constants.primcolor,
          title: const Text(
            "Order Medicin",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
              onPressed: () {
                Get.find<OrderMedicinController>().prescrip_image_base64.value =
                    "";
                Get.find<OrderMedicinController>().image.value = File("");
                Get.find<OrderMedicinController>().is_image.value == false;

                Get.back();
              },
              icon: const FaIcon(
                FontAwesomeIcons.angleLeft,
                color: Colors.white,
              )),
        ),
        body: Stack(
          children: [
            Container(
              width: Get.width,
              height: 70,
              padding: const EdgeInsets.only(left: 20, top: 15),
              decoration: const BoxDecoration(
                  color: Constants.primcolor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "prescription ",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    "please upload your valid prescription",
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Obx(
                      () => Container(
                        width: Get.width,
                        height: 200,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Constants.primcolor,
                                style: BorderStyle.solid),
                            color: Constants.primcolor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Get.find<OrderMedicinController>()
                                .prescrip_image_base64
                                .value
                                .isNotEmpty
                            ? Image(
                                image: FileImage(
                                    Get.find<OrderMedicinController>()
                                        .image
                                        .value),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  FaIcon(FontAwesomeIcons.upload),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "upload Prescription",
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1),
                            child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    side: const BorderSide(
                                        color: Constants.primcolor),
                                    backgroundColor: Constants.whitesmoke,
                                    elevation: 0,
                                    padding: const EdgeInsets.all(10)),
                                onPressed: () {
                                  Get.find<OrderMedicinController>()
                                      .getpres_camera();
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.camera,
                                  color: Constants.primcolor.withOpacity(0.7),
                                ),
                                label: const Text(
                                  "Camera",
                                  style: TextStyle(color: Constants.primcolor),
                                )),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(1),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    side: const BorderSide(
                                        color: Constants.primcolor),
                                    backgroundColor: Constants.whitesmoke,
                                    elevation: 0,
                                    padding: const EdgeInsets.all(10)),
                                onPressed: () {
                                  Get.find<OrderMedicinController>()
                                      .getpres_gallery();
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.image,
                                  color: Constants.primcolor.withOpacity(0.7),
                                ),
                                label: const Text("Gallery",
                                    style:
                                        TextStyle(color: Constants.primcolor)),
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 150,
                    ),
                    SizedBox(
                        child: Center(
                      child: Mutation(
                        options: MutationOptions(
                          document: gql(Mymutation.order_medicin),
                          onCompleted: (data) {
                            Get.find<OrderMedicinController>()
                                .is_ordering
                                .value = false;
                            Get.find<OrderMedicinController>()
                                .prescrip_image_base64
                                .value = "";
                            Get.find<OrderMedicinController>().image.value =
                                File("");
                            Get.find<OrderMedicinController>().is_image.value ==
                                false;

                            Get.find<SignUpController>()
                                .sucss_customsnack("Orderd succsfully!");

                            Get.offNamed("/mainhomepage");
                          },
                        ),
                        builder: (runMutationOrder, result) {
                          if (result!.hasException) {
                            print(result.exception.toString());
                          }
                          if (result.isLoading) {
                            Get.find<OrderMedicinController>()
                                .is_ordering
                                .value = true;
                          }
                          return Mutation(
                              options: MutationOptions(
                                document: gql(Mymutation.calc_delivery_fee),
                                onCompleted: (data) {
                                  if (data!.isNotEmpty) {
                                    //run ordermutation
                                    runMutationOrder({
                                      "user_id": Get.find<SplashController>()
                                          .prefs
                                          .getInt("id"),
                                      "presc_image":
                                          Get.find<OrderMedicinController>()
                                              .uploded_image
                                              .value,
                                      "ph_id": pharmacy["id"],
                                      "user_lat":
                                          Get.find<Locationcontrollers>()
                                              .current_lat
                                              .value,
                                      "user_long":
                                          Get.find<Locationcontrollers>()
                                              .current_long
                                              .value,
                                      "user_loc":
                                          Get.find<Locationcontrollers>()
                                              .address
                                              .value,
                                      "del_cost": data["calculateDeliveryFee"]
                                          ["price"],
                                      "user_city":
                                          Get.find<Locationcontrollers>()
                                              .city
                                              .value,
                                      "distance": data["calculateDeliveryFee"]
                                          ["distance"]
                                    });
                                  }
                                },
                              ),
                              builder: (runMutationCalDelfee, result) {
                                if (result!.hasException) {
                                  print(result.exception.toString());
                                }
                                if (result.isLoading) {
                                  Get.find<OrderMedicinController>()
                                      .is_ordering
                                      .value = true;
                                }
                                return Mutation(
                                  options: MutationOptions(
                                    document: gql(Mymutation.upload_image),
                                    onCompleted: (data) {
                                      //run calc delivery fee mutation
                                      Get.find<OrderMedicinController>()
                                          .uploded_image
                                          .value = data!["uploadImage"]["id"];

                                      runMutationCalDelfee({
                                        "ph_lat": pharmacy["phlat"],
                                        "ph_long": pharmacy["phlong"],
                                        "user_lat":
                                            Get.find<Locationcontrollers>()
                                                .current_lat
                                                .value,
                                        "user_long":
                                            Get.find<Locationcontrollers>()
                                                .current_long
                                                .value
                                      });
                                    },
                                    onError: (error) {
                                      print(error.toString());
                                    },
                                  ),
                                  builder: (runMutationUploadimage, result) {
                                    if (result!.hasException) {
                                      Get.find<OrderMedicinController>()
                                          .is_ordering
                                          .value = false;
                                      print(result.exception.toString());
                                    }
                                    if (result.isLoading) {
                                      Get.find<OrderMedicinController>()
                                          .is_ordering
                                          .value = true;
                                    }
                                    return Obx(() =>
                                        // SwipeableButtonView(
                                        //           buttonText: 'Slide to Order',
                                        //           buttonWidget: const Icon(
                                        //             Icons.arrow_forward_ios_rounded,
                                        //             color: Constants.primcolor,
                                        //           ),
                                        //           isActive: Get.find<
                                        //                           OrderMedicinController>()
                                        //                       .prescrip_image_base64
                                        //                       .value ==
                                        //                   ""
                                        //               ? false
                                        //               : true,
                                        //           activeColor: Constants.primcolor,
                                        //           isFinished: Get.find<
                                        //                   OrderMedicinController>()
                                        //               .is_ordering
                                        //               .value,
                                        //           onWaitingProcess: () async {},
                                        //           onFinish: () async {
                                        //             runMutationUploadimage({
                                        //               "image": Get.find<
                                        //                       OrderMedicinController>()
                                        //                   .prescrip_image_base64
                                        //                   .value
                                        //             });
                                        //           },
                                        //         )

                                        SizedBox(
                                          width: Get.width,
                                          height: 50,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10)),
                                                onPressed: () async {
                                                  if (Get.find<
                                                              OrderMedicinController>()
                                                          .prescrip_image_base64
                                                          .value ==
                                                      "") {
                                                    Get.find<SignUpController>()
                                                        .customsnack(
                                                            "please provide your prescription");
                                                  } else {
                                                    // run cal upload prescription mutation
                                                    runMutationUploadimage({
                                                      "image": Get.find<
                                                              OrderMedicinController>()
                                                          .prescrip_image_base64
                                                          .value
                                                    });
                                                  }
                                                },
                                                icon:
                                                    Get.find<OrderMedicinController>()
                                                                .is_ordering
                                                                .value ==
                                                            true
                                                        ? const ButtonSpinner()
                                                        : const Icon(
                                                            Icons.send),
                                                label:
                                                    Get.find<OrderMedicinController>()
                                                                .is_ordering
                                                                .value ==
                                                            true
                                                        ? const Text("ordering")
                                                        : const Text("Order")),
                                          ),
                                        ));
                                  },
                                );
                              });
                        },
                      ),
                    )

                        //cal delivery fee mutation

                        )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
