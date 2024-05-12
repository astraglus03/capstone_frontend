class ChatThreadId {
  final String threadId;

  ChatThreadId({
    required this.threadId,
  });
  factory ChatThreadId.fromJson(Map<String, dynamic> json) {
    return ChatThreadId(
      threadId: json['threadId'],
    );
  }
}