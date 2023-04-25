enum ChatBotMessageType { user, bot }

class ChatBotMessage {
  final text;
  final ChatBotMessageType chatBotMessageType;

  ChatBotMessage({required this.text, required this.chatBotMessageType});
}
