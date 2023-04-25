import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hakimea/controllers/user_controllers/ordercontroller.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

import '../../../../utils/constants.dart';

class OrderDetail extends StatelessWidget {
  OrderDetail({super.key});

  var order_id = Get.arguments;

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
            onPressed: () => Get.back(),
            icon: const FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Colors.white,
            )),
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
              //prescription
              // const Padding(
              //   padding: EdgeInsets.all(10),
              //   child: Text(
              //     "Prescription",
              //     style: TextStyle(fontWeight: FontWeight.bold),
              //   ),
              // ),
              // AnimationConfiguration.staggeredList(
              //   position: 1,
              //   child: ScaleAnimation(
              //     child: FadeInAnimation(
              //       child: Container(
              //         width: Get.width,
              //         height: 150,
              //         margin: const EdgeInsets.all(10),
              //         decoration: const BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.all(Radius.circular(10)),
              //         ),
              //         child: Row(
              //           children: [
              //             ClipRRect(
              //               borderRadius: const BorderRadius.only(
              //                   topLeft: Radius.circular(10),
              //                   bottomLeft: Radius.circular(10)),
              //               child: InstaImageViewer(
              //                 child: CachedNetworkImage(
              //                   imageUrl:
              //                       "https://media.istockphoto.com/id/1144689517/photo/caduceus-medical-symbol-isolated.jpg?s=612x612&w=is&k=20&c=XeH9fFQ6H9oF9CDziIss6l2mTzUgbONvK5vc0AI4h2Q=",
              //                   width: 150,
              //                   height: 150,
              //                   placeholder: (context, url) =>
              //                       const Icon(Icons.image),
              //                   errorWidget: (context, url, error) =>
              //                       const Icon(Icons.error),
              //                   fit: BoxFit.cover,
              //                 ),
              //               ),
              //             ),
              //             const SizedBox(
              //               width: 20,
              //             ),
              //             Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: const [
              //                 Text("Order Code",
              //                     style: TextStyle(color: Colors.black54)),
              //                 SizedBox(
              //                   height: 10,
              //                 ),
              //                 Text(
              //                   "hk23454",
              //                   style: TextStyle(
              //                       fontWeight: FontWeight.bold, fontSize: 18),
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              // medicines
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
                      children: const [
                        Text(
                          "Your medicin",
                          style: TextStyle(color: Colors.black54),
                        ),
                        Text(
                          "code: HK34545",
                          style: TextStyle(
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
                        children: const [Text("Medicin"), Text("Quantity")],
                      ),
                    ),
                    // medicin list
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        child: InstaImageViewer(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "https://media.istockphoto.com/id/606218650/fr/photo/m%C3%A9dicaments.webp?s=1024x1024&w=is&k=20&c=LINctpwKDi-5uqKcQ1z33JwXz8phdkH-V_SC9jPWNvM=",
                                            width: 70,
                                            height: 70,
                                            placeholder: (context, url) =>
                                                const Icon(Icons.image),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      title: const Text("Paracetamol"),
                                      subtitle: const Text(
                                        "1 per pain",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    )),
                                    const Text("3"),
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
                      children: const [
                        Text("SubTotal",
                            style: TextStyle(color: Colors.black54)),
                        Text(
                          "ETB 100",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
                        Text("TOTAL", style: TextStyle(color: Colors.black54)),
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
                                    .pharma_payment_method
                                    .value ==
                                ""
                            ? false
                            : true,
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
