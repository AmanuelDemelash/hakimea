import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class notification_card extends StatelessWidget {
  String title;
  String type;
  String desc;
  notification_card(
      {Key? key, required this.title, required this.type, required this.desc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 150,
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: const BoxDecoration(color: Colors.white54),
      child: Column(
        children: [
          ListTile(
            leading: type == "confirmed"
                ? Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.withOpacity(0.2)),
                    child: const Center(
                        child: FaIcon(
                      FontAwesomeIcons.calendar,
                      color: Colors.green,
                    )),
                  )
                : type == "cancelled"
                    ? Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red.withOpacity(0.2)),
                        child: const Center(
                            child: FaIcon(
                          FontAwesomeIcons.cancel,
                          color: Colors.red,
                        )),
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.withOpacity(0.2)),
                        child: const Center(
                            child: FaIcon(
                          FontAwesomeIcons.calendar,
                          color: Colors.blue,
                        )),
                      ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Flexible(
              child: Text(
                desc,
                style: const TextStyle(color: Colors.black54),
              ),
            ),
          )
        ],
      ),
    );
  }
}
