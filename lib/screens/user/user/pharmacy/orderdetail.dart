import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/myquery.dart';
import 'package:hakimea/controllers/user_controllers/ordercontroller.dart';
import 'package:hakimea/widgets/cool_loading.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

import '../../../../utils/constants.dart';

class OrderDetail extends StatelessWidget {
  OrderDetail({super.key});

  Map<String, dynamic> order = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.primcolor,
        title: const Text(
          "Order detail",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Get.find<OrderController>().is_medicins_returned.value = false;
              Get.find<OrderController>().pharma_payment_method.value == "";

              Get.back();
            },
            icon: const FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Colors.white,
            )),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const FaIcon(
                FontAwesomeIcons.trash,
              ))
        ],
      ),
      body: Stack(children: [
        Container(
            width: Get.width,
            height: 50,
            decoration: const BoxDecoration(
                color: Constants.primcolor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)))),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                width: Get.width,
                margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Your medicin",
                          style: TextStyle(color: Colors.black54),
                        ),
                        Text(
                          "code: ${order["order_code"]}",
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.black12,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [Text("Medicin"), Text("Price")],
                      ),
                    ),
                    // medicin list

                    Query(
                      options: QueryOptions(
                          document: gql(Myquery.order_medicins),
                          variables: {"id": order["id"]},
                          pollInterval: const Duration(seconds: 10)),
                      builder: (result, {fetchMore, refetch}) {
                        if (result.isLoading) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              cool_loding(),
                              Text(
                                "please wait! your order is being processing",
                                style: TextStyle(color: Colors.black54),
                              ),
                              SizedBox(
                                height: 30,
                              )
                            ],
                          );
                        }
                        List? medicins = result.data!["medicine_order_detail"];
                        if (medicins!.isEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              cool_loding(),
                              Text(
                                "please wait! your order is being processing",
                                style: TextStyle(color: Colors.black54),
                              ),
                              SizedBox(
                                height: 30,
                              )
                            ],
                          );
                        } else {
                          Get.find<OrderController>()
                                  .is_medicins_returned
                                  .value =
                              !Get.find<OrderController>()
                                  .is_medicins_returned
                                  .value;
                        }

                        return Column(
                          children: [
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: medicins.length,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child: ListTile(
                                              leading: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                child: InstaImageViewer(
                                                  child: CachedNetworkImage(
                                                    imageUrl: medicins[index]
                                                        ["image"]["url"],
                                                    width: 60,
                                                    height: 60,
                                                    placeholder: (context,
                                                            url) =>
                                                        const Icon(Icons.image),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              title: Text(medicins[index]
                                                  ["medicine_name"]),
                                              subtitle: Text(
                                                medicins[index]
                                                    ["medicine_description"],
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    color: Colors.black54),
                                              ),
                                            )),
                                            Text(medicins[index]
                                                    ["medicine_price"]
                                                .toString()),
                                          ],
                                        ),
                                      )),
                                );
                              },
                            ),

                            const Divider(
                              color: Colors.black45,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            // total price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("SubTotal",
                                    style: TextStyle(color: Colors.black54)),
                                Text(
                                  "ETB ${order["total_cost"].toString()}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            // delivery cost
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("Delivery fee",
                                    style: TextStyle(color: Colors.black54)),
                                Text(
                                  "ETB 50",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Divider(
                              color: Colors.black54,
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            // total
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("TOTAL",
                                    style: TextStyle(color: Colors.black54)),
                                Text(
                                  "ETB 150",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              //payment option
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Payment Option.",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              AnimationConfiguration.staggeredList(
                position: 0,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: Container(
                      width: Get.width,
                      height: 200,
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          const Text("Pay With"),
                          const Text(
                            "choose payment option to pay for your medicin!",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          //cash
                          Row(
                            children: [
                              Obx(() => Radio(
                                    value: "cash",
                                    groupValue: Get.find<OrderController>()
                                        .pharma_payment_method
                                        .value,
                                    onChanged: (value) {
                                      Get.find<OrderController>()
                                          .pharma_payment_method
                                          .value = value.toString();
                                    },
                                    activeColor: Constants.primcolor,
                                  )),
                              const Text("Cash on delivery"),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // chapa
                          Row(
                            children: [
                              Obx(() => Radio(
                                    value: "chapa",
                                    groupValue: Get.find<OrderController>()
                                        .pharma_payment_method
                                        .value,
                                    onChanged: (value) {
                                      Get.find<OrderController>()
                                          .pharma_payment_method
                                          .value = value.toString();
                                    },
                                    activeColor: Constants.primcolor,
                                  )),
                              const Image(
                                image: AssetImage("assets/images/chapa.png"),
                                width: 100,
                                height: 50,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // accept button
              Container(
                margin: const EdgeInsets.all(20),
                child: Center(
                  child: Obx(() => SwipeableButtonView(
                        buttonText: 'SLIDE TO Confirm',
                        buttonWidget: Container(
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey,
                          ),
                        ),
                        isActive: Get.find<OrderController>()
                                    .is_medicins_returned
                                    .value ==
                                true
                            ? Get.find<OrderController>()
                                    .pharma_payment_method
                                    .value
                                    .isNotEmpty
                                ? true
                                : false
                            : false,
                        activeColor: Constants.primcolor,
                        isFinished: Get.find<OrderController>()
                            .is_confirm_button_finshed
                            .value,
                        onWaitingProcess: () {},
                        onFinish: () async {
                          Get.find<OrderController>()
                              .is_confirm_button_finshed
                              .value = true;
                        },
                      )),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
