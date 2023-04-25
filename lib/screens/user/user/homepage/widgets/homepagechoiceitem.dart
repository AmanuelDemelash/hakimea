import 'package:flutter/material.dart';
import 'package:get/get.dart';

class homepage_choice extends StatelessWidget {
  String title;
  String path;
  homepage_choice({Key? key, required this.title, required this.path})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.only(right: 5),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            path,
            width: 30,
            height: 30,
          ),
          const SizedBox(
            height: 10,
          ),
          Flexible(
            child: Text(
              title.tr,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          )
        ],
      ),
    );
  }
}
