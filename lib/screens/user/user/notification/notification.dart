import 'package:emoji_alert/arrays.dart';
import 'package:emoji_alert/emoji_alert.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/mymutation.dart';
import 'package:hakimea/apiservice/myquery.dart';
import 'package:hakimea/apiservice/subscriptions.dart';
import 'package:hakimea/controllers/notification_controller.dart';
import 'package:hakimea/controllers/splashcontroller.dart';
import 'package:hakimea/widgets/cool_loading.dart';
import '../../../../utils/constants.dart';
import 'widgets/notificatin_shimmer.dart';
import 'widgets/notification_card.dart';

class MyNotification extends StatefulWidget {
  const MyNotification({Key? key}) : super(key: key);

  @override
  State<MyNotification> createState() => _MyNotificationState();
}

class _MyNotificationState extends State<MyNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Constants.whitesmoke,
          title: const Text(
            "Notifications",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const FaIcon(
                FontAwesomeIcons.angleLeft,
                color: Colors.black,
              )),
        ),
        body: Get.find<SplashController>().prefs.getString("token") == null
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
                    mainButtonText: const Text("OK"),
                    animationType: ANIMATION_TYPE.ROTATION,
                  ),
                ))
            : Subscription(
                options: SubscriptionOptions(
                  document: gql(MySubscription.user_notification),
                  variables: {
                    "id": Get.find<SplashController>().prefs.getInt("id")
                  },
                ),
                builder: (resultt) {
                  if (resultt.hasException) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return const notification_shimmer();
                      },
                    );
                  }
                  if (resultt.isLoading) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return const notification_shimmer();
                      },
                    );
                  }
                  List? notific = resultt.data!["notifications"];
                  if (notific!.isEmpty) {
                    return const Center(child: Text("No notification"));
                  }

                  return ResultAccumulator.appendUniqueEntries(
                      latest: resultt.data,
                      builder: (p0, {results}) {
                        if (notific.isNotEmpty) {
                          Get.find<NotificationController>().crateNotification(
                              notific.last!["title"],
                              notific.last!["description"]);
                        }
                        return SizedBox(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: notific.length,
                            itemBuilder: (context, index) {
                              return Mutation(
                                options: MutationOptions(
                                  document: gql(Mymutation.delete_notification),
                                ),
                                builder: (runMutation, result) {
                                  if (result!.isLoading) {
                                    return const cool_loding();
                                  }
                                  return Dismissible(
                                    key: UniqueKey(),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) async {
                                      runMutation({"id": notific[index]["id"]});
                                      setState(() {
                                        notific.removeAt(index);
                                      });
                                    },
                                    child: notification_card(
                                      title: notific[index]["title"],
                                      desc: notific[index]["description"],
                                      type: notific[index]["type"],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      });
                },
              ));
  }
}
