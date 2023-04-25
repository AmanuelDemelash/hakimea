import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hakimea/controllers/splashcontroller.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onbordscreen extends StatelessWidget {
  Onbordscreen({super.key});

  final PageController _pageController = PageController(
      initialPage: Get.find<SplashController>().currentonbord_screen.value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
              child: GetBuilder<SplashController>(
                  init: Get.find<SplashController>(),
                  initState: (_) {},
                  builder: (controller) {
                    return PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: Get.height / 1.7,
                                width: Get.width,
                                child: const ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(120)),
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/onbordone.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Thousands of doctors & experts to help your health",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Constants.primcolor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: Get.height / 1.7,
                                width: Get.width,
                                child: const ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(120)),
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/onbordtwo.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Health cheek and consolations easily anywhere anytime",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Constants.primcolor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: Get.height / 1.7,
                                width: Get.width,
                                child: const ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(120)),
                                  child: Image(
                                    image: AssetImage(
                                        "assets/images/onbordthr.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Lets start living healthy and well with us right now!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Constants.primcolor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onPageChanged: (value) {
                        Get.find<SplashController>()
                            .currentonbord_screen
                            .value = value;
                      },
                    );
                  })),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    3,
                    (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          margin: const EdgeInsets.all(5),
                          width: Get.find<SplashController>()
                                      .currentonbord_screen
                                      .value ==
                                  index
                              ? 25
                              : 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: Get.find<SplashController>()
                                          .currentonbord_screen
                                          .value ==
                                      index
                                  ? Constants.primcolor
                                  : Constants.primcolor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20)),
                        )),
              )),
          const SizedBox(
            height: 60,
          ),
          Container(
              margin: const EdgeInsets.all(14),
              width: Get.width,
              child: Obx(() => ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15)),
                        onPressed: () async {
                          var page = Get.find<SplashController>()
                                  .currentonbord_screen
                                  .value +
                              1;
                          if (page == 3) {
                            Get.find<SplashController>()
                                .prefs
                                .setBool('firsttime', false);
                            Get.offNamed("/login");
                          }
                          _pageController.jumpToPage(page);
                        },
                        child: Get.find<SplashController>()
                                    .currentonbord_screen
                                    .value ==
                                2
                            ? const Text("Get Started")
                            : const Text("Next")),
                  )))
        ],
      ),
    );
  }
}
