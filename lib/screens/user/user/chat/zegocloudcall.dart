import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/mymutation.dart';
import 'package:hakimea/controllers/splashcontroller.dart';
import 'package:hakimea/controllers/user_controllers/myappointmentcontroller.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../../controllers/notification_controller.dart';

class ZegoCloudCall extends StatelessWidget {
  ZegoCloudCall({super.key});

  var user_data = Get.arguments;

  Future<void> _onWillPop(BuildContext context) async {
    await showDialog(
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title:
            const Text("Are you sure?", style: TextStyle(color: Colors.black)),
        content: const Text(
            "Do you want to exit an App? this will end the call ",
            style: TextStyle(color: Colors.black)),
        actions: [
          ElevatedButton(
            child: const Text("NO", style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          Mutation(
            options: MutationOptions(
              document: gql(Mymutation.update_wallet_withdraw),
              onCompleted: (data) {
                Get.find<NotificationController>().crateNotification(
                    "Appointment complated",
                    "your appointment was  succesfully complated. please contact us if any problem happen");
                Get.find<MyappointmentController>().is_complating.value = false;
                Get.toNamed("/review", arguments: user_data["id"]);
              },
            ),
            builder: (runMutation, result) {
              if (result!.hasException) {
                print(result.exception);
                Get.find<MyappointmentController>().is_complating.value = false;
              }
              return Mutation(
                options: MutationOptions(
                  document: gql(Mymutation.update_appo_statuss),
                  onCompleted: (data) {
                    if (data!.isNotEmpty) {
                      //run wallet update mutation
                      runMutation({
                        "id": user_data["doc_id"],
                        "wallet":
                            user_data["wallet"] + int.parse(user_data["price"])
                      });
                    }
                  },
                ),
                builder: (runMutation, result) {
                  if (result!.hasException) {
                    print(result.exception.toString());
                    Get.find<MyappointmentController>().is_complating.value =
                        false;
                  }
                  if (result.isLoading) {
                    Get.find<MyappointmentController>().is_complating.value =
                        true;
                  }
                  return ElevatedButton(
                    child: const Text("YES",
                        style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      //run complate mutation
                      runMutation(
                          {"id": user_data["id"], "status": "completed"});
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onWillPop(context);
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: ZegoUIKitPrebuiltCall(
            appID:
                908879844, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
            appSign:
                "05c29c487ef8a119bf82bde76b1383cea2750ac6078c2a9cb72299787bce56b6", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
            userID: Get.find<SplashController>().prefs.getInt("id").toString(),
            userName: user_data["full_name"],
            callID: user_data["channel"],
            onDispose: () {},
            config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
              ..turnOnCameraWhenJoining = true
              ..turnOnMicrophoneWhenJoining = false
              ..useSpeakerWhenJoining = true
              ..onHangUpConfirmation = (BuildContext context) async {
                return await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: const Text("Do you want to end the call?",
                          style: TextStyle(color: Colors.black)),
                      content: const Text(
                          "if you end the call the session complates ",
                          style: TextStyle(color: Colors.black)),
                      actions: [
                        ElevatedButton(
                          child: const Text("NO",
                              style: TextStyle(color: Colors.black)),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        Mutation(
                          options: MutationOptions(
                            document: gql(Mymutation.update_wallet_withdraw),
                            onCompleted: (data) {
                              Get.find<MyappointmentController>()
                                  .is_complating
                                  .value = false;
                              Get.toNamed("/review",
                                  arguments: user_data["id"]);
                            },
                          ),
                          builder: (runMutation, result) {
                            if (result!.hasException) {
                              print(result.exception);
                              Get.find<MyappointmentController>()
                                  .is_complating
                                  .value = false;
                            }
                            return Mutation(
                              options: MutationOptions(
                                document: gql(Mymutation.update_appo_statuss),
                                onCompleted: (data) {
                                  if (data!.isNotEmpty) {
                                    //run wallet update mutation
                                    runMutation({
                                      "id": user_data["doc_id"],
                                      "wallet": user_data["wallet"] +
                                          int.parse(user_data["price"])
                                    });
                                  }
                                },
                              ),
                              builder: (runMutation, result) {
                                if (result!.hasException) {
                                  print(result.exception.toString());
                                  Get.find<MyappointmentController>()
                                      .is_complating
                                      .value = false;
                                }
                                if (result.isLoading) {
                                  Get.find<MyappointmentController>()
                                      .is_complating
                                      .value = true;
                                }
                                return ElevatedButton(
                                  child: const Text("YES",
                                      style: TextStyle(color: Colors.black)),
                                  onPressed: () {
                                    //run complate mutation
                                    runMutation({
                                      "id": user_data["id"],
                                      "status": "completed"
                                    });
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              ..audioVideoViewConfig = ZegoPrebuiltAudioVideoViewConfig(
                backgroundBuilder: (BuildContext context, Size size,
                    ZegoUIKitUser? user, Map extraInfo) {
                  return user != null
                      ? ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Image(
                            image: NetworkImage(
                              user_data["photo"],
                            ),
                            fit: BoxFit.cover,
                          ))
                      : const SizedBox();
                },
              )
              ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(
                  hideAutomatically: false, hideByClick: true)
              ..audioVideoViewConfig = ZegoPrebuiltAudioVideoViewConfig(
                foregroundBuilder: (BuildContext context, Size size,
                    ZegoUIKitUser? user, Map extraInfo) {
                  return user != null
                      ? Positioned(
                          bottom: 5,
                          left: 5,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/user.png",
                                  ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        )
                      : const SizedBox();
                },
              )
              ..avatarBuilder = (BuildContext context, Size size,
                  ZegoUIKitUser? user, Map extraInfo) {
                return user != null
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                user_data["photo"],
                              ),
                              fit: BoxFit.cover),
                        ),
                      )
                    : const SizedBox();
              },
          ),
        ),
      ),
    );
  }

  exit(int i) {}
}
