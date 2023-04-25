import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hakimea/controllers/translationcontroller.dart';
import 'package:hakimea/theme/dark_theme.dart';
import 'package:hakimea/theme/light_theme.dart';
import 'package:hakimea/utils/constants.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.whitesmoke,
          elevation: 0,
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const FaIcon(
                FontAwesomeIcons.angleLeft,
                color: Colors.black,
              )),
          title: const Text(
            "Setting",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                //lamguage
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.earth),
                  title: Text('language'.tr),
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
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'en', child: Text("English")),
                      const PopupMenuItem(value: 'am', child: Text("Amharic")),
                    ],
                  ),
                ),
                //theme
                ListTile(
                    leading: const Icon(Icons.visibility),
                    title: const Text("Dark Mode"),
                    trailing: Obx(() => Switch.adaptive(
                          value:
                              Get.find<TransalationControlers>().is_dark.value,
                          onChanged: (value) {
                            Get.find<TransalationControlers>().is_dark.value =
                                value;
                            if (Get.find<TransalationControlers>()
                                    .is_dark
                                    .value ==
                                true) {
                              Get.changeTheme(dark);
                            }
                          },
                        ))),
              ],
            )));
  }
}
