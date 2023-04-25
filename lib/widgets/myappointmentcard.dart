import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hakimea/utils/constants.dart';

class myappointment_card extends StatelessWidget {
  const myappointment_card({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(seconds: 2),
        width: Get.width,
        height:90,
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
        ),
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
           const SizedBox(width: 5,),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: CachedNetworkImage(
                width:70,
                height:70,
                fit: BoxFit.cover,
                imageUrl:
                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80',
              ),
            ),
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.all(5),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Dr. Aman root"),
                      const SizedBox(height:7,),
                      Row(
                        children: [
                          const Text(
                            "Voice call",
                            style: TextStyle(color: Colors.black54, fontSize: 13),
                          ),
                          const SizedBox(width: 15,),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green.withOpacity(0.1),
                            ),
                            child: const Text(
                              "Pending",
                              style: TextStyle(fontSize: 10, color: Colors.green),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: const [
                          FaIcon(
                            FontAwesomeIcons.calendar,
                            color: Constants.primcolor,
                            size: 12,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text("32,Oct, 2022/ 12:00am",
                              style: TextStyle(color: Colors.black54, fontSize: 13))
                        ],
                      )
                    ],
                  ),

                  trailing:
                      Container(
                        width:40,
                        height:40,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Constants.primcolor.withOpacity(0.2)),
                        child: const Center(
                          child:  FaIcon(
                            FontAwesomeIcons.phone,
                            color: Constants.primcolor,
                            size: 15,
                          ),
                        ),
                      ),

                   ),
            ),
          ],
        )
    );
  }
}
