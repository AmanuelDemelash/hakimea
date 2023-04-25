import 'package:badges/badges.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/mymutation.dart';
import 'package:hakimea/apiservice/myquery.dart';
import 'package:hakimea/apiservice/subscriptions.dart';
import 'package:hakimea/controllers/user_controllers/myappointmentcontroller.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:hakimea/widgets/cool_loading.dart';
import 'package:hakimea/widgets/loading.dart';

import '../../../../controllers/splashcontroller.dart';

class ChatDetail extends StatelessWidget {
  ChatDetail({super.key});

  TextEditingController _message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.whitesmoke,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Colors.black,
            )),
        title: SizedBox(
            height: 60,
            child: Query(
              options: QueryOptions(
                  document: gql(Myquery.chat_doc_profile),
                  variables: {"id": Get.arguments},
                  pollInterval: const Duration(seconds: 4)),
              builder: (result, {fetchMore, refetch}) {
                var chat_header = result.data!["doctors_by_pk"];
                if (result.isLoading) {
                  return ListTile();
                }
                return ListTile(
                    leading: Stack(children: [
                      CircleAvatar(
                        backgroundImage: chat_header["profile_image"] == null
                            ? const AssetImage("assets/images/user.png")
                                as ImageProvider
                            : NetworkImage(chat_header["profile_image"]["url"]),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 3,
                        child: Badge(
                          showBadge: chat_header["is_online"] ?? false,
                          badgeColor: Colors.green,
                        ),
                      )
                    ]),
                    title: Text(
                      "${chat_header["full_name"]}",
                    ),
                    subtitle: chat_header["is_online"] == null
                        ? const Text("")
                        : chat_header["is_online"] == true
                            ? const Text(
                                "Online",
                                style: TextStyle(color: Constants.primcolor),
                              )
                            : const Text(
                                "Online",
                                style: TextStyle(color: Constants.primcolor),
                              ));
              },
            )),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            itemBuilder: (context) =>
                const [PopupMenuItem(child: Text("delete chat"))],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Expanded(
                child: Subscription(
              options: SubscriptionOptions(
                document: gql(MySubscription.chat_body),
                variables: {
                  "doctor_id": Get.arguments,
                  "user_id": Get.find<SplashController>().prefs.getInt("id")
                },
              ),
              builder: (result) {
                if (result.hasException) {
                  return Text(result.exception.toString());
                }

                if (result.isLoading) {
                  return const Center(
                    child: loading(),
                  );
                }

                if (result.data!.isEmpty) {
                  return const Center(
                    child: Text("no chat yet"),
                  );
                }
                return ResultAccumulator.appendUniqueEntries(
                  latest: result.data,
                  builder: (context, {results}) =>
                      AnimationConfiguration.staggeredList(
                    position: 1,
                    child: ListView.builder(
                        reverse: true,
                        itemCount: result.data!["chats"].length,
                        itemBuilder: (context, index) {
                          if (result.data!["chats"][index]["from"] ==
                              "doctor") {
                            return SlideAnimation(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          result.data!["chats"][index]["doctor"]
                                              ["profile_image"]["url"]),
                                    ),
                                    AnimatedContainer(
                                      duration:
                                          const Duration(microseconds: 500),
                                      child: ChatBubble(
                                        alignment: Alignment.centerRight,
                                        backGroundColor:
                                            Colors.white.withOpacity(0.8),
                                        clipper: ChatBubbleClipper4(
                                            type: BubbleType.receiverBubble),
                                        elevation: 10,
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          child: Flexible(
                                            child: Text(
                                              result.data!["chats"][index]
                                                  ["message"],
                                              style: const TextStyle(
                                                  color: Constants.primcolor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return SlideAnimation(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    AnimatedContainer(
                                      duration:
                                          const Duration(microseconds: 500),
                                      child: ChatBubble(
                                        elevation: 10,
                                        alignment: Alignment.centerRight,
                                        backGroundColor: Constants.primcolor
                                            .withOpacity(0.8),
                                        clipper: ChatBubbleClipper4(
                                            type: BubbleType.sendBubble),
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          child: Flexible(
                                            child: Text(
                                              result.data!["chats"][index]
                                                  ["message"],
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        }),
                  ),
                );
              },
            )),
            // loading
            Obx(
              () => Visibility(
                  visible: Get.find<MyappointmentController>()
                      .is_sending_message
                      .value,
                  child: const cool_loding()),
            ),
            // send message
            Mutation(
              options: MutationOptions(
                document: gql(Mymutation.send_message),
                onCompleted: (data) {
                  Get.find<MyappointmentController>().is_sending_message.value =
                      false;
                },
              ),
              builder: (runMutation, result) {
                if (result!.hasException) {
                  print(result.exception.toString());
                }
                if (result.isLoading) {
                  Get.find<MyappointmentController>().is_sending_message.value =
                      true;
                }
                return Container(
                  width: Get.width,
                  height: 80,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        controller: _message,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return null;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "write message",
                            filled: true,
                            prefixIcon: IconButton(
                                onPressed: () => Get.bottomSheet(BottomSheet(
                                    onClosing: () {},
                                    builder: (context) {
                                      return AnimatedContainer(
                                        duration:
                                            const Duration(microseconds: 500),
                                      );
                                    })),
                                icon: const FaIcon(
                                  FontAwesomeIcons.chain,
                                  size: 18,
                                )),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  if (_message.text.isNotEmpty) {
                                    Get.find<MyappointmentController>()
                                        .is_sending_message
                                        .value = true;
                                    runMutation({
                                      "doctor_id": Get.arguments,
                                      "user_id": Get.find<SplashController>()
                                          .prefs
                                          .getInt("id"),
                                      "from": "user",
                                      "to": "doctor",
                                      "message": _message.text.toString()
                                    });
                                    _message.text = "";
                                  }
                                },
                                icon: const Icon(
                                  Icons.send,
                                  size: 25,
                                  color: Colors.grey,
                                )),
                            border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Constants.whitesmoke),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Constants.whitesmoke),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Constants.whitesmoke),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            fillColor: Colors.white),
                      )),
                      IconButton(
                          onPressed: () {
                            Get.find<MyappointmentController>()
                                .is_emoje_show
                                .value = Get.find<MyappointmentController>()
                                    .is_emoje_show
                                    .value
                                ? false
                                : true;
                          },
                          icon: const Icon(
                            Icons.emoji_emotions,
                            size: 27,
                            color: Colors.black26,
                          )),
                    ],
                  ),
                );
              },
            ),
            Obx(() => Offstage(
                  offstage:
                      !Get.find<MyappointmentController>().is_emoje_show.value,
                  child: SizedBox(
                      height: 250,
                      child: EmojiPicker(
                        textEditingController: _message,
                        config: Config(
                          columns: 7,
                          emojiSizeMax: 18,
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          gridPadding: EdgeInsets.zero,
                          initCategory: Category.RECENT,
                          bgColor: Constants.primcolor.withOpacity(0.3),
                          indicatorColor: Colors.blue,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.blue,
                          backspaceColor: Colors.blue,
                          skinToneDialogBgColor: Colors.white,
                          skinToneIndicatorColor: Colors.grey,
                          enableSkinTones: true,
                          showRecentsTab: true,
                          recentsLimit: 28,
                          replaceEmojiOnLimitExceed: false,
                          noRecents: const Text(
                            'No Recents',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black26),
                            textAlign: TextAlign.center,
                          ),
                          loadingIndicator: SizedBox.shrink(),
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL,
                          checkPlatformCompatibility: true,
                        ),
                      )),
                )),
          ],
        ),
      ),
    );
  }
}
