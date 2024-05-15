class QandASendModel {
  final String userId;
  final String threadId;
  final String text;

  QandASendModel({
    required this.userId,
    required this.threadId,
    required this.text,
  });

  factory QandASendModel.fromJson(Map<String, dynamic> json) {
    return QandASendModel(
      userId: json['userId'],
      threadId: json['threadId'],
      text: json['text'],
    );
  }
}