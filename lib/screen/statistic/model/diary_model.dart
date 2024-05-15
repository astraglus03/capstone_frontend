import 'dart:convert';
import 'dart:typed_data';

class DiaryModel {
  final String? userId;
  final DateTime? date;
  final Uint8List? image;
  final String? content;
  final List<String>? textEmotion;
  final List<String>? speechEmotion;
  final int? chatCount;
  final List<String>? absEmotion;

  DiaryModel({
    this.userId,
    this.date,
    this.image,
    this.content,
    this.textEmotion,
    this.speechEmotion,
    this.chatCount,
    this.absEmotion,
  });

  factory DiaryModel.fromJson(Map<String, dynamic> json) {
    String base64String = json['image'] ?? '';
    Uint8List image = base64Decode(base64String);
    return DiaryModel(
      userId: json['userId'] ?? 'Unknown',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      image: image,
      content: json['content'] ?? '',
      textEmotion: json['textEmotion'] != null ? List<String>.from(json['textEmotion']) : [],
      speechEmotion: json['speechEmotion'] != null ? List<String>.from(json['speechEmotion']) : [],
      chatCount: json['chatCount'] ?? 0,
      absEmotion: json['absEmotion'] != null ? List<String>.from(json['absEmotion']) : [],
    );
  }
}
