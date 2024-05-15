class ChatRespModel{
  final String message;
  final int emotion;
  final int status;

  ChatRespModel({
    required this.message,
    required this.emotion,
    required this.status,
  });
  factory ChatRespModel.fromJson(Map<String, dynamic> json) {
    return ChatRespModel(
      message: json['message'],
      emotion: json['emotion'],
      status: json['status'],
    );
  }
}