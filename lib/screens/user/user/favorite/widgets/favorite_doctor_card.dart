import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hakimea/utils/constants.dart';

class favorite_doctor_card extends StatelessWidget {
  String image;
  String name;
  String spec;
  favorite_doctor_card(
      {Key? key, required this.image, required this.name, required this.spec})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: Get.width,
      margin: const EdgeInsets.only(bottom: 6),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 10,
          ),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: CachedNetworkImage(
              imageUrl: image,
              width: 50,
              height: 50,
              placeholder: (context, url) => const Icon(Icons.image),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Dr. $name "),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  spec,
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.favorite,
              color: Constants.primcolor.withOpacity(0.3),
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
    );
  }
}
