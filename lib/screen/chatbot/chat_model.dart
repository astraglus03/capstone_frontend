import 'dart:io';

class ChatResponse{
  final String message;
  final String emotion;
  final int status;

  ChatResponse(this.message, this.emotion, this.status,);
  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      json['message'],
      json['emotion'],
      json['status'],
    );
  }
}