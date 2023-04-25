import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

class top_doctors extends StatelessWidget {
  String name;
  String speciality;
  String image;
  int id;
  double rate;
  top_doctors(
      {Key? key,
      required this.name,
      required this.speciality,
      required this.image,
      required this.rate,
      required this.id})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed("/doctorprofile", arguments: id),
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Material(
          shadowColor: Colors.white54,
          type: MaterialType.card,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 150,
            height: 225,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(50)),
                  child: InstaImageViewer(
                    backgroundIsTransparent: true,
                    child: CachedNetworkImage(
                      imageUrl: image,
                      width: 150,
                      height: 150,
                      placeholder: (context, url) => Icon(
                        Icons.image,
                        color: Constants.primcolor.withOpacity(0.5),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "Dr.$name",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      )
                    ]),
                Text(
                  speciality,
                  style: const TextStyle(
                    color: Colors.black45,
                  ),
                ),
                RatingBar.builder(
                  initialRating: rate,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 9,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Constants.secondcolor,
                  ),
                  onRatingUpdate: (rating) {},
                ),
                const SizedBox(
                  height: 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
