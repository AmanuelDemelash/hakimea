import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../utils/constants.dart';

class pharmacy_card extends StatelessWidget {
  int id;
  String image;
  String name;
  String location;
  int rate;
  String owner_name;
  String phone_number;
  String owner_image;
  String open_time;
  String close_time;

  pharmacy_card(
      {Key? key,
      required this.id,
      required this.image,
      required this.location,
      required this.name,
      required this.rate,
      required this.owner_name,
      required this.owner_image,
      required this.phone_number,
      required this.close_time,
      required this.open_time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Get.width,
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 9),
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                //pharmacy pic
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: image.toString(),
                    width: 60,
                    height: 60,
                    placeholder: (context, url) => const Icon(Icons.image),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(2),
                      title: Text(name.toString()),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(location.toString()),
                          const SizedBox(
                            height: 5,
                          ),
                          RatingBar.builder(
                            initialRating: rate.toDouble(),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 11,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Constants.primcolor,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                      trailing: GestureDetector(
                        onTap: () async {
                          launch("tel:$phone_number");
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: const BoxDecoration(
                              color: Constants.primcolor,
                              shape: BoxShape.circle),
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.phone,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),

            //time
            const Text(
              "Opening time",
              style: TextStyle(color: Colors.black45),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.clock,
                  size: 13,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text("$open_time-$close_time")
              ],
            ),
            // owner
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Owner",
              style: TextStyle(color: Colors.black45),
            ),
            const SizedBox(
              height: 5,
            ),

            Row(
              children: [
                CircleAvatar(
                  radius: 11,
                  backgroundColor: Constants.primcolor,
                  backgroundImage: NetworkImage(owner_image),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(owner_name)
              ],
            )
          ],
        ));
  }
}
