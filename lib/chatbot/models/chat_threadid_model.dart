class ChatThreadIdModel {
  final String threadId;
  final String message;
  final int emotion;

  ChatThreadIdModel({
    required this.threadId,
    required this.message,
    required this.emotion,
  });
  factory ChatThreadIdModel.fromJson(Map<String, dynamic> json) {
    return ChatThreadIdModel(
      threadId: json['chat_thread'],
      message: json['message'],
      emotion: json['emotion'],
    );
  }
}