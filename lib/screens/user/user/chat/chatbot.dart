import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hakimea/controllers/user_controllers/chatbotcontroller.dart';
import 'package:hakimea/model/chatbot.dart';
import 'package:hakimea/widgets/cool_loading.dart';

import '../../../../utils/constants.dart';

class ChatBot extends StatelessWidget {
  ChatBot({super.key});

  TextEditingController _textcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.primcolor,
        centerTitle: true,
        title: const Text(
          "Chat Bot",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Colors.white,
            )),
      ),
      body: Column(
        children: [
          // messages
          Expanded(
              child: Obx(() => ListView.builder(
                    itemCount:
                        Get.find<ChatBotController>().messages.value.length,
                    itemBuilder: (context, index) {
                      return Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Get.find<ChatBotController>()
                                          .messages
                                          .value[index]
                                          .chatBotMessageType ==
                                      ChatBotMessageType.user
                                  ? FaIcon(FontAwesomeIcons.person)
                                  : FaIcon(FontAwesomeIcons.bots),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(Get.find<ChatBotController>()
                                  .messages
                                  .value[index]
                                  .text),
                            ],
                          ));
                    },
                  ))),

          // loading
          Obx(() => Visibility(
              visible: Get.find<ChatBotController>().is_sending_message.value,
              child: cool_loding())),

          // send message
          Container(
            width: Get.width,
            height: 50,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                color: Colors.white),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: _textcontroller,
                  decoration: const InputDecoration(
                      hintText: "Message ", border: InputBorder.none),
                )),
                IconButton(
                    onPressed: () {
                      // add user message
                      Get.find<ChatBotController>().messages.value.add(
                          ChatBotMessage(
                              text: _textcontroller.text,
                              chatBotMessageType: ChatBotMessageType.user));

                      // get response and add bot message
                      Get.find<ChatBotController>()
                          .getmessage(_textcontroller.text);

                      _textcontroller.text = "";
                    },
                    icon: const Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
    );
  }
}
