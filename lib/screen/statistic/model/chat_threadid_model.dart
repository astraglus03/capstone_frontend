class ChatThreadIdModel {
  final String threadId;

  ChatThreadIdModel({
    required this.threadId,
  });
  factory ChatThreadIdModel.fromJson(Map<String, dynamic> json) {
    return ChatThreadIdModel(
      threadId: json['chat_thread'],
    );
  }
}