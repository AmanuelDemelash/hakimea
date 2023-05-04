import 'dart:io';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hakimea/screens/user/user/appointment/myappointment.dart';
import 'package:hakimea/screens/user/user/doctor_detail/doctorsearch.dart';
import 'package:hakimea/screens/user/user/profile/myprofile.dart';
import 'package:hakimea/utils/constants.dart';
import '../../../controllers/user_controllers/homepagecontroller.dart';
import 'homepage/homepage.dart';

class MainHomePage extends StatelessWidget {
  MainHomePage({super.key});

  final _pagecontroller = PageController(initialPage: 0);

  Future<void> _onWillPop(BuildContext context) async {
    await showDialog(
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => exit(0),
            child:
                const Text('Yes', style: TextStyle(color: Constants.primcolor)),
          ),
        ],
      ),
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _advancedDrawerController = AdvancedDrawerController();
    return WillPopScope(
      onWillPop: () async {
        _onWillPop(context);
        return true;
      },
      child: AdvancedDrawer(
          backdropColor: Constants.primcolor,
          controller: Get.find<HomePageController>().advancedDrawerController,
          animationCurve: Curves.bounceIn,
          animationDuration: const Duration(milliseconds: 300),
          animateChildDecoration: true,
          rtlOpening: false,
          openScale: 1.0,
          disabledGestures: false,
          childDecoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          drawer: Drawer(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Container(

                        decoration: const BoxDecoration(
                            //color: Colors.white,
                            ),
                        child: CircleAvatar(
                            radius: 70,
                            backgroundColor:
                                Constants.primcolor.withOpacity(0.3),
                            backgroundImage: const AssetImage(
                                "assets/images/splash_logo.png"))),
                    const Text(
                      "Hakime ET V1.0",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "V1.0",
                      style: TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(
                      height:100,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 10),
                      decoration: const BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: ListTile(
                        onTap: () {
                          Get.toNamed("/history");
                        },
                        leading: const FaIcon(
                          FontAwesomeIcons.history,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "History",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        trailing: const FaIcon(
                          FontAwesomeIcons.angleRight,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 10),
                      decoration: const BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: ListTile(
                        leading: const FaIcon(
                          FontAwesomeIcons.earth,
                          color: Colors.white,
                        ),
                        title: Text(
                          'language'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        trailing: PopupMenuButton(
                          padding: const EdgeInsets.only(left: 40),
                          icon: const FaIcon(
                            FontAwesomeIcons.angleRight,
                            color: Colors.white,
                          ),
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
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 10),
                      decoration: const BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: ListTile(
                          leading: const Icon(
                            Icons.visibility,
                            color: Colors.white,
                          ),
                          title: const Text(
                            "Dark Mode",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          trailing: Switch.adaptive(
                            value: false,
                            onChanged: (value) {},
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          child: Scaffold(
            backgroundColor: Constants.whitesmoke,
            body: SizedBox(
              width: Get.width,
              height: Get.height,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pagecontroller,
                children: [
                  Homepage(),
                  DoctorSearch(),
                  Myappointment(),
                  Myprofile()
                ],
              ),
            ),
            //destination screen
            floatingActionButton: FloatingActionButton(
                backgroundColor: Constants.primcolor,
                elevation: 10,
                onPressed: () {
                  Get.toNamed("/nearbymap");
                },
                child: const Icon(Icons.local_pharmacy)),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: Obx(() => AnimatedBottomNavigationBar(
                    icons: const [
                      Icons.home,
                      Icons.search,
                      Icons.calendar_month,
                      Icons.person,
                    ],
                    activeIndex:
                        Get.find<HomePageController>().current_bnb_item.value,
                    iconSize: 25,
                    backgroundColor: Constants.primcolor,
                    blurEffect: true,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white54,
                    gapLocation: GapLocation.center,
                    notchSmoothness: NotchSmoothness.verySmoothEdge,
                    leftCornerRadius: 12,
                    rightCornerRadius: 12,
                    onTap: (index) {
                      Get.find<HomePageController>().current_bnb_item.value =
                          index;
                      _pagecontroller.jumpToPage(index);
                    })),
          )),
    );
  }
}
