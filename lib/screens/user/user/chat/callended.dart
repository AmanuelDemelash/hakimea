import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hakimea/utils/constants.dart';

import '../../../../controllers/user_controllers/homepagecontroller.dart';

class CallEnded extends StatelessWidget {
  const CallEnded({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.whitesmoke,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: Center(
                    child: Column(
                      children: const [
                        SizedBox(
                          height: 200,
                        ),
                        Center(
                          child: Text(
                            "Call Ended",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "20:49  min",
                          style: TextStyle(
                              color: Constants.primcolor,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                              "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                child: Column(
                  children: [
                    Container(
                        width: Get.width,
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        child:
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  padding: const EdgeInsets.all(20)),
                              onPressed: () {
                                Get.toNamed("/review");
                              },
                              child: const Text(
                                "Write a Review",
                              )),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: Get.width,
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        child: 
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Constants.primcolor.withOpacity(0.8),
                                  padding: const EdgeInsets.all(20)),
                              onPressed: () {
                                Get.find<HomePageController>()
                                    .current_bnb_item
                                    .value = 0;
                                Get.offAllNamed("/mainhomepage");
                              },
                              child: const Text(
                                "Goto Homepage",
                                style: TextStyle(color: Colors.white),
                              )),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
