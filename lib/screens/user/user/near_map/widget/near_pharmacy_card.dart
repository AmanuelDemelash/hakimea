import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../utils/constants.dart';

class near_pharmacy_card extends StatelessWidget {
  int id;
  String name;
  String location;
  String image;
  String open_time;
  String close_time;
  String phone;
  double phlat;
  double phlong;

  near_pharmacy_card(
      {Key? key,
      required this.id,
      required this.location,
      required this.image,
      required this.name,
      required this.open_time,
      required this.close_time,
      required this.phlat,
      required this.phlong,
      required this.phone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width / 1.2,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Constants.primcolor.withOpacity(0.4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: Get.width,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: image,
                        width: 60,
                        height: 130,
                        placeholder: (context, url) => Icon(
                          Icons.image,
                          color: Constants.primcolor.withOpacity(0.5),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Flexible(child: Text(name)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 7,
                        ),
                        Flexible(
                            child: Text(
                          location,
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 15),
                        )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  thickness: 1,
                ),
                // time
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "working time",
                            style: TextStyle(color: Colors.black54),
                          ),
                          Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.clock,
                                size: 12,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                "$open_time- $close_time",
                                style: const TextStyle(
                                    color: Colors.black54, fontSize: 13),
                              )
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          launch("tel:$phone");
                        },
                        child: Container(
                            width: 35,
                            height: 35,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Constants.primcolor),
                            child: const Center(
                                child: FaIcon(
                              FontAwesomeIcons.phone,
                              color: Colors.white,
                              size: 16,
                            ))),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),

          const SizedBox(
            height: 10,
          ),
          // order button
          SizedBox(
            width: Get.width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15)),
                  onPressed: () async {
                    Get.toNamed("/ordermedicin", arguments: {
                      "id": id,
                      "phlat": phlat,
                      "phlong": phlong,
                      "name": name,
                      "image": image,
                      "location": location
                    });
                  },
                  child: const Text("Order Medicin")),
            ),
          )
        ],
      ),
    );
  }
}
