import 'dart:convert';

import 'package:get/get.dart';
import 'package:hakimea/apiservice/service.dart';
import 'package:hakimea/model/chatbot.dart';
import 'package:hakimea/screens/user/user/chat/chatbot.dart';

class ChatBotController extends GetxController {
  var is_sending_message = false.obs;
  Rx<List<ChatBotMessage>> messages = Rx<List<ChatBotMessage>>([]);

  Future<void> getmessage(String prompt) async {
    is_sending_message.value = true;

    var response = await MyServices().getchatmessage(prompt);
    if (response.statusCode == 200) {
      is_sending_message.value = false;
      Map<String, dynamic> newres = jsonDecode(response.body);
      messages.value.add(ChatBotMessage(
          text: newres['choices'][0]['text'],
          chatBotMessageType: ChatBotMessageType.bot));
    }
  }
}
