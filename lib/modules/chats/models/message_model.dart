class Message {
  final String sender;
  final String content;
  String? format = 'msg';

  Message({
    required this.sender,
    required this.content,
    this.format,
  });
}

class Chat {
  List<Message> messages = [];

  void addMessage(Message message) {
    messages.add(message);
  }
}
