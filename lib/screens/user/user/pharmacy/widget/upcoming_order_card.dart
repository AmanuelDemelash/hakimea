import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants.dart';

class UpcomingOrderCard extends StatelessWidget {
  int id;
  String phname;
  String location;
  String image;
  String code;
  String date;
  UpcomingOrderCard(
      {Key? key,
      required this.id,
      required this.code,
      required this.image,
      required this.location,
      required this.date,
      required this.phname})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 90,
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            child: CachedNetworkImage(
              imageUrl: image,
              width: 80,
              height: 80,
              placeholder: (context, url) => const Icon(Icons.image),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(child: Text(phname)),
              Flexible(
                child: Text(
                  location,
                  style: const TextStyle(color: Colors.black54, fontSize: 15),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                date.substring(0, 10),
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
              Row(
                children: [
                  const Text(
                    "Order Code: ",
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  Text(
                    code,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
          trailing: GestureDetector(
            onTap: () => Get.toNamed("/orderdetailstatus", arguments: id),
            child: Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  color: Constants.primcolor.withOpacity(0.3),
                  shape: BoxShape.circle),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.angleRight,
                  color: Constants.primcolor,
                ),
              ),
            ),
          ),
        ));
  }
}
