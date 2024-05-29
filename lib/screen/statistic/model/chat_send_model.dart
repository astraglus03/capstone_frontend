import 'dart:io';

class ChatSendModel {
  final String userId;
  final String threadId;
  final String content;
  final File audioFile;
  final double weight;

  ChatSendModel({
    required this.userId,
    required this.threadId,
    required this.content,
    required this.audioFile,
    required this.weight,
  });
  factory ChatSendModel.fromJson(Map<String, dynamic> json) {
    return ChatSendModel(
      userId: json['userId'],
      threadId: json['threadId'],
      content: json['content'],
      audioFile: json['audioFile'],
      weight: json['weight'],
    );
  }
}
