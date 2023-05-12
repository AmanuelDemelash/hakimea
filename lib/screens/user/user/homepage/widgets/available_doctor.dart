import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_alert/arrays.dart';
import 'package:emoji_alert/emoji_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

import '../../../../../controllers/splashcontroller.dart';

class available_doctor extends StatelessWidget {
  String name;
  String speciality;
  String image;
  int id;
  double rate;
  int rate_count;
  int exp_year;
  bool is_online;

  available_doctor(
      {Key? key,
      required this.id,
      required this.image,
      required this.exp_year,
      required this.name,
      required this.rate,
      required this.rate_count,
      required this.speciality,
      required this.is_online})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed("/doctorprofile", arguments: id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: 150,
        height: 329,
        margin: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
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
                      width: Get.width,
                      height: 180,
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
                is_online == true
                    ? Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 60,
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: const Center(
                            child: Text(
                              "Online",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                        ),
                      )
                    : Text("")
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "Dr. $name",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                speciality,
                style: const TextStyle(
                  color: Colors.black45,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.orange,
                  size: 13,
                ),
                Text(rate.toString()),
                Text("(${rate_count.toString()})"),
                const Icon(
                  Icons.cases_sharp,
                  color: Constants.primcolor,
                  size: 13,
                ),
                Text(exp_year.toString()),
                const Text("Years")
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              width: Get.width,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      backgroundColor: Constants.primcolor.withOpacity(0.8),
                      elevation: 0),
                  onPressed: () {
                    if (Get.find<SplashController>().prefs.getString("token") ==
                        null) {
                      EmojiAlert(
                        alertTitle: const Text("Login",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        description: Column(
                          children: const [
                            Text("You need to login first"),
                          ],
                        ),
                        enableMainButton: true,
                        mainButtonColor: Constants.primcolor,
                        onMainButtonPressed: () {
                          Navigator.pop(context);
                          Get.offAllNamed("/login");
                        },
                        cancelable: true,
                        emojiType: EMOJI_TYPE.SAD,
                        height: 260,
                        mainButtonText: const Text("OK"),
                        animationType: ANIMATION_TYPE.ROTATION,
                      ).displayAlert(context);
                    } else {
                      Get.offAllNamed("/appointment", arguments: id);
                    }
                  },
                  icon: const Icon(
                    Icons.timelapse,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "book Appointment",
                    style: TextStyle(fontSize: 12,color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
