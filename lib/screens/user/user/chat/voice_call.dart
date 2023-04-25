import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/mymutation.dart';
import 'package:hakimea/widgets/buttonspinner.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

import '../../../../controllers/notification_controller.dart';
import '../../../../controllers/splashcontroller.dart';
import '../../../../controllers/user_controllers/myappointmentcontroller.dart';

class VoiceCall extends StatelessWidget {
  VoiceCall({super.key});

  var user_data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: ZegoUIKitPrebuiltLiveAudioRoom(
                appID:
                    908879844, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
                appSign:
                    "05c29c487ef8a119bf82bde76b1383cea2750ac6078c2a9cb72299787bce56b6", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
                userID:
                    Get.find<SplashController>().prefs.getInt("id").toString(),
                userName: user_data["full_name"],
                roomID: user_data["channel"],
                config: (user_data["isHost"]
                    ? (ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
                      ..takeSeatIndexWhenJoining = 0)
                    : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience())
                  ..seatConfig.showSoundWaveInAudioMode = true
                  ..layoutConfig.rowConfigs = [
                    ZegoLiveAudioRoomLayoutRowConfig(
                        count: 2,
                        alignment: ZegoLiveAudioRoomLayoutAlignment.center)
                  ]
                  ..onLeaveConfirmation = (BuildContext context) async {
                    return await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text("Are you sure?",
                              style: TextStyle(color: Colors.black)),
                          content: const Text(
                              "this makes the session complated  ",
                              style: TextStyle(color: Colors.black54)),
                          actions: [
                            Expanded(
                              child: ElevatedButton(
                                child: const Text("No",
                                    style: TextStyle(color: Colors.white70)),
                                onPressed: () => Get.back(),
                              ),
                            ),
                            Mutation(
                              options: MutationOptions(
                                document:
                                    gql(Mymutation.insert_notification_doc),
                                onCompleted: (data) {
                                  Get.toNamed("/review",
                                      arguments: user_data["id"]);
                                },
                              ),
                              builder: (runMutation, result) {
                                return Mutation(
                                  options: MutationOptions(
                                    document:
                                        gql(Mymutation.update_wallet_withdraw),
                                    onCompleted: (data) {
                                      Get.find<NotificationController>()
                                          .crateNotification(
                                              "Appointment complated",
                                              "your appointment was  succesfully complated. please contact us if any problem happen");
                                      Get.find<MyappointmentController>()
                                          .is_complating
                                          .value = false;
                                      runMutation({
                                        "title": "Appointment complated",
                                        "description":
                                            "your appointment with your patient is completed.. ETB ${user_data["price"]} is added to your wallet",
                                        "type": "completed",
                                        "doctor_id": user_data["doc_id"]
                                      });
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
                                        document:
                                            gql(Mymutation.update_appo_statuss),
                                        onCompleted: (data) {
                                          // run update wallet
                                          runMutation({
                                            "id": user_data["doc_id"],
                                            "wallet": user_data["wallet"] +
                                                int.parse(user_data["price"])
                                          });
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
                                        return Expanded(
                                          child: ElevatedButton(
                                              child:
                                                  Get.find<MyappointmentController>()
                                                              .is_complating
                                                              .value ==
                                                          true
                                                      ? Row(
                                                          children: const [
                                                            ButtonSpinner(),
                                                            Text("wait..")
                                                          ],
                                                        )
                                                      : const Text("Yes",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white70)),
                                              onPressed: () =>
                                                  Get.find<SplashController>()
                                                              .prefs
                                                              .getBool(
                                                                  "isdoctor") ==
                                                          true
                                                      ? Navigator.of(context)
                                                          .pop(true)
                                                      : runMutation({
                                                          "id": user_data["id"],
                                                          "status": "completed"
                                                        })),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            )
                          ],
                        );
                      },
                    );
                  }
                  ..seatConfig.avatarBuilder = (context, size, user,
                          extraInfo) =>
                      Get.find<SplashController>().prefs.getBool("isdoctor") ==
                              true
                          ? CircleAvatar(
                              maxRadius: size.width,
                              backgroundImage: NetworkImage(user_data["photo"]))
                          : CircleAvatar(
                              maxRadius: size.width,
                              backgroundImage: const AssetImage(
                                "assets/images/user.png",
                              )))));
  }
}
