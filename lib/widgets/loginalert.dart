import 'package:emoji_alert/arrays.dart';
import 'package:emoji_alert/emoji_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants.dart';

class loginalert extends StatelessWidget {
  const loginalert({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
        ));
  }
}
