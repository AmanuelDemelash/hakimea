import 'dart:ui';

import 'package:emoji_alert/arrays.dart';
import 'package:emoji_alert/emoji_alert.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/myquery.dart';
import 'package:hakimea/controllers/splashcontroller.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:shimmer/shimmer.dart';

class Myprofile extends StatelessWidget {
  Myprofile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const FaIcon(
                FontAwesomeIcons.angleLeft,
                color: Colors.black,
              )),

          elevation: 0,
        ),
        body: Get.find<SplashController>().prefs.getString("token") == null
            ? SizedBox(
                width: Get.width,
                height: Get.height,
                child: Center(
                  child: EmojiAlert(
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
                    mainButtonText: const Text("LogIn"),
                    animationType: ANIMATION_TYPE.ROTATION,
                  ),
                ))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // profile pic
                    Query(
                      options: QueryOptions(
                          document: gql(Myquery.userprofile),
                          variables: {
                            "id":
                                Get.find<SplashController>().prefs.getInt("id")
                          }),
                      builder: (result, {fetchMore, refetch}) {
                        if (result.hasException) {}
                        if (result.isLoading) {
                          return Container(
                            width: Get.width,
                            height: 200,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(100))),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Stack(children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade200,
                                    highlightColor: Colors.white,
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                ]),
                                const SizedBox(
                                  height: 10,
                                ),
                                Shimmer.fromColors(
                                  baseColor: Colors.grey.shade200,
                                  highlightColor: Colors.white,
                                  child: Container(
                                    width: 100,
                                    height: 15,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Shimmer.fromColors(
                                  baseColor: Colors.grey.shade200,
                                  highlightColor: Colors.white,
                                  child: Container(
                                    width: 100,
                                    height: 15,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                        return Container(
                          width: Get.width,
                          height: 200,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(100))),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Stack(children: [
                                CircleAvatar(
                                    radius: 60,
                                    backgroundColor:
                                        Constants.primcolor.withOpacity(0.3),
                                    backgroundImage: result.data!["users_by_pk"]
                                                ["profile_image"] ==
                                            null
                                        ? AssetImage("assets/images/user.png")
                                            as ImageProvider
                                        : NetworkImage(
                                                result.data!["users_by_pk"]
                                                    ["profile_image"]["url"])
                                            as ImageProvider),
                                Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Constants.primcolor),
                                    child: Center(
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: const FaIcon(
                                            FontAwesomeIcons.camera,
                                            color: Colors.white,
                                            size: 13,
                                          )),
                                    ),
                                  ),
                                )
                              ]),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                result.data!["users_by_pk"]["full_name"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                result.data!["users_by_pk"]["phone_number"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    //edit account
                    ListTile(
                      onTap: () => Get.toNamed("/editprofile"),
                      leading: const Icon(Icons.person),
                      title: const Text("Edit Account"),
                      trailing: const FaIcon(FontAwesomeIcons.angleRight),
                    ),
                    const ListTile(
                      leading: FaIcon(FontAwesomeIcons.moneyBill),
                      title: Text("Payment"),
                      trailing: FaIcon(FontAwesomeIcons.angleRight),
                    ),
                    //nptification
                    ListTile(
                      onTap: () {
                        Get.toNamed("/notification");
                      },
                      leading: const FaIcon(FontAwesomeIcons.bell),
                      title: Text("notification".tr),
                      trailing: const FaIcon(FontAwesomeIcons.angleRight),
                    ),
                    //lamguage
                    ListTile(
                      leading: const FaIcon(FontAwesomeIcons.earth),
                      title: Text('language'.tr),
                      trailing: PopupMenuButton(
                        padding: const EdgeInsets.only(left: 40),
                        icon: const FaIcon(FontAwesomeIcons.angleRight),
                        onSelected: (value) {
                          if (value == 'am') {
                            Get.updateLocale(Locale('am', 'ET'));
                          }
                          if (value == 'en') {
                            Get.updateLocale(Locale('en', 'US'));
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                              value: 'en', child: Text("English")),
                          const PopupMenuItem(
                              value: 'am', child: Text("Amharic")),
                        ],
                      ),
                    ),
                    //theme
                    ListTile(
                        leading: const Icon(Icons.visibility),
                        title: const Text("Dark Mode"),
                        trailing: Switch.adaptive(
                          value: false,
                          onChanged: (value) {},
                        )),
                    //help
                    const ListTile(
                      leading: FaIcon(FontAwesomeIcons.servicestack),
                      title: Text("Help center"),
                      trailing: FaIcon(FontAwesomeIcons.angleRight),
                    ),
                    ListTile(
                      onTap: () async {
                        await Get.find<SplashController>().prefs.remove('id');
                        await Get.find<SplashController>()
                            .prefs
                            .remove('token');
                        await Get.find<SplashController>()
                            .prefs
                            .remove('isdoctor');
                        Get.offAllNamed("/login");
                      },
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      title: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
