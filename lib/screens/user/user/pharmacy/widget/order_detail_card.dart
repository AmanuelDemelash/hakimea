import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../utils/constants.dart';

class order_detail_card extends StatelessWidget {
  Map<String, String> delivery;
  String status;
  order_detail_card({Key? key, required this.delivery, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: Get.width,
          height:300,
          decoration: const BoxDecoration(
              color: Constants.primcolor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Expanded(child: SizedBox()),
                  Expanded(
                    child: Divider(
                      color: Constants.whitesmoke,
                      thickness: 2,
                    ),
                  ),
                  Expanded(child: SizedBox())
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // delivery man
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: delivery.isEmpty
                    ?
                Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:const [
                          CircularProgressIndicator(
                            color: Colors.white,
                          ),
                          SizedBox(height: 5,),
                          Text(
                            "your delivery man is not yet assigned",
                            style: TextStyle(
                              color:Colors.white54,
                            ),
                          ),
                          Text(
                            "please wait!",
                            style: TextStyle(
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      )
                    :
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                      delivery["image"]!,
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(delivery["name"]!,
                                        style: const TextStyle(
                                            color: Constants.whitesmoke,
                                            fontSize: 16)),
                                    const Text("delivery person",
                                        style:
                                            TextStyle(color: Colors.white54)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: ()async{
                              launch("tel:${delivery["phone"]}");

                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Constants.whitesmoke),
                              child: const Center(
                                child: FaIcon(
                                  FontAwesomeIcons.phone,
                                  size: 20,
                                  color: Constants.primcolor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: Get.width,
              height: 165,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      // status
                      Container(
                        margin: const EdgeInsets.only(
                            left: 40, right: 40, top: 20, bottom: 5),
                        child: Row(
                          children: [
                            FaIcon(FontAwesomeIcons.fileMedical,
                                color: status != "pending"
                                    ? Constants.secondcolor
                                    : Constants.primcolor.withOpacity(0.5)),
                            Expanded(
                              child: Divider(
                                indent: 5,
                                endIndent: 5,
                                color: status == "on_delivery"
                                    ? Constants.secondcolor
                                    : Constants.primcolor.withOpacity(0.5),
                                thickness: 3,
                              ),
                            ),
                            FaIcon(
                              FontAwesomeIcons.bicycle,
                              color: status == "on_delivery"
                                  ? Constants.secondcolor
                                  : Constants.primcolor.withOpacity(0.5),
                            ),
                            Expanded(
                              child: Divider(
                                indent: 5,
                                endIndent: 5,
                                color: Constants.primcolor.withOpacity(0.5),
                                thickness: 3,
                              ),
                            ),
                            FaIcon(
                              FontAwesomeIcons.checkToSlot,
                              color: status == "delivered"
                                  ? Constants.secondcolor
                                  : Constants.primcolor.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Order accepted",
                              style: TextStyle(
                                color: status != "pending"
                                    ? Constants.secondcolor
                                    : Constants.primcolor.withOpacity(0.5),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "On deliverd",
                              style: TextStyle(
                                color: status == "on_delivery"
                                    ? Constants.secondcolor
                                    : Constants.primcolor.withOpacity(0.5),
                              ),
                            ),
                            const Spacer(flex: 2),
                            Text(
                              "Done",
                              style: TextStyle(
                                color: status == "delivered"
                                    ? Constants.secondcolor
                                    : Constants.primcolor.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  Text(
                    "your order is already on its way to you!",
                    style:
                        TextStyle(color: Constants.primcolor.withOpacity(0.6)),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}
