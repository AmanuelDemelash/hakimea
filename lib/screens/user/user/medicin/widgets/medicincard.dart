
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

import '../../../../../utils/constants.dart';

class MedicinCard extends StatelessWidget {
  int id;
  String image;
  String name;
  String price;
  String pname;
  String ploc;
  MedicinCard({Key? key,required this.id, required this.name,required this.image,required this.price,required this.pname,required this.ploc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
              Radius.circular(15))),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: const BorderRadius.all(
              Radius.circular(10)),
          child:
          InstaImageViewer(
            child: CachedNetworkImage(
              imageUrl:
              image.toString(),
              width: 70,
              height: 70,
              placeholder: (context, url) =>
              const Icon(Icons.image),
              errorWidget: (context, url, error) =>
              const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Flexible(
            child: Text(name)),
        subtitle: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(pname),
            const SizedBox(height: 10,),
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.locationDot,size: 13,color: Constants.primcolor,),
                const SizedBox(width: 5,),
                Text(ploc),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
        trailing: Text(
          "ETB $price",
          style: const TextStyle(
              color: Colors.black),
        ),
      ),
    );
  }
}
