import 'package:flutter/material.dart';
import 'package:get/get.dart';

class no_appointment_found extends StatelessWidget {
  String title;
  no_appointment_found({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          const Image(
            image: AssetImage(
              "assets/images/no_data.png",
            ),
            fit: BoxFit.cover,
            width: 200,
            height: 200,
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
