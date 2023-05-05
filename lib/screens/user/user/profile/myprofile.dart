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

      body: Get
          .find<SplashController>()
          .prefs
          .getString("token") == null
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
          : SafeArea(
        child: SingleChildScrollView(
            child: Column(
                children: [
            // profile pic
            Query(
            options: QueryOptions(
            document: gql(Myquery.userprofile),
            variables: {
              "id":
              Get
                  .find<SplashController>()
                  .prefs
                  .getInt("id")
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
          return Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: Get.width,
                    height: 190,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: Get.width,
                      height: 100,
                      decoration: const BoxDecoration(
                          color: Constants.primcolor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    top: 20,
                    left: Get.width / 2 - 50,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white

                          ),
                          child: CircleAvatar(
                              radius: 50,
                              backgroundColor:
                              Constants.primcolor.withOpacity(0.3),
                              backgroundImage: result.data!["users_by_pk"]
                              ["profile_image"] ==
                                  null
                                  ? const AssetImage("assets/images/user.png")
                                  : NetworkImage(
                                  result.data!["users_by_pk"]
                                  ["profile_image"]["url"])
                              as ImageProvider),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          result.data!["users_by_pk"]["full_name"],
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              result.data!["users_by_pk"]["sex"],
                              style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                            const VerticalDivider(color: Colors.black54,thickness: 2,width: 10),
                            Text(
                              result.data!["users_by_pk"]["date_of_birth"],
                              style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),

                          ],
                        ),

                      ],
                    ),
                  )
                ],
              ),
              // info
              Container(
                width: Get.width,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Information",
                      style: TextStyle(color: Colors.black, fontSize: 18),),
                    //edit account
                    ListTile(
                      leading: const Icon(Icons.phone,color: Colors.black54,),
                      title:const Text("Phone",style: TextStyle(color: Colors.black54),),
                      trailing:Text(result.data!["users_by_pk"]["phone_number"],style:const TextStyle(color: Colors.black),),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email,color: Colors.black54,),
                      title:const Text("Email",style: TextStyle(color: Colors.black54),),
                      trailing:Text(result.data!["users_by_pk"]["email"],style:const TextStyle(color: Colors.black),),
                    ),

                  ],
                ),
              ),
            ],
          );
        },
      ),

      const SizedBox(height: 8,),

      //setting
      Container(
        width: Get.width,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child:Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            const Text("Setting",
              style: TextStyle(color: Colors.black, fontSize: 18),),
            //edit account
            ListTile(
              onTap: () => Get.toNamed("/editprofile"),
              leading: const Icon(Icons.person),
              title: const Text("Edit Account",style: TextStyle(color: Colors.black54),),
              trailing: const FaIcon(FontAwesomeIcons.angleRight),
            ),
            const ListTile(
              leading: FaIcon(FontAwesomeIcons.moneyBill),
              title: Text("Payment",style: TextStyle(color: Colors.black54),),
              trailing: FaIcon(FontAwesomeIcons.angleRight),
            ),
            //nptification
            ListTile(
              onTap: () {
                Get.toNamed("/notification");
              },
              leading: const FaIcon(FontAwesomeIcons.bell),
              title: Text("notification".tr,style:const TextStyle(color: Colors.black54),),

              trailing: const FaIcon(FontAwesomeIcons.angleRight),
            ),
            //lamguage
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.earth),
              title: Text('language'.tr,style:const TextStyle(color: Colors.black54),),
              trailing: PopupMenuButton(
                padding: const EdgeInsets.only(left: 40),
                icon: const FaIcon(FontAwesomeIcons.angleRight),
                onSelected: (value) {
                  if (value == 'am') {
                    Get.updateLocale(const Locale('am', 'ET'));
                  }
                  if (value == 'en') {
                    Get.updateLocale(const Locale('en', 'US'));
                  }
                },
                itemBuilder: (context) =>
                [
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
                title: const Text("Dark Mode",style:const TextStyle(color: Colors.black54),),
                trailing: Switch.adaptive(
                  value: false,
                  onChanged: (value) {},
                )),
          ],
        )
      ),
      const SizedBox(height: 8,),
      //more
      Container(
        width: Get.width,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("More",
              style: TextStyle(color: Colors.black, fontSize: 18),),
            //help
            const ListTile(
              leading: FaIcon(FontAwesomeIcons.servicestack),
              title: Text("Help center"),
              trailing: FaIcon(FontAwesomeIcons.angleRight),
            ),
            ListTile(
              onTap: () async {
                await Get
                    .find<SplashController>()
                    .prefs
                    .remove('id');
                await Get
                    .find<SplashController>()
                    .prefs
                    .remove('token');
                await Get
                    .find<SplashController>()
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
        )


      ),
        ],
      ),
    ),)
    );
  }
}
