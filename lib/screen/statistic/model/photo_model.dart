import 'dart:convert';
import 'dart:typed_data';

class PhotoModel {
  final String userId;
  final DateTime date;
  final Uint8List image;
  // final String content;
  // final List<String> textEmotion;
  // final List<String> speechEmotion;
  // final int charCount;

  PhotoModel({
    required this.userId,
    required this.date,
    required this.image,
    // required this.content,
    // required this.textEmotion,
    // required this.speechEmotion,
    // required this.charCount,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    String base64String = json['image'];
    Uint8List image = base64Decode(base64String);
    return PhotoModel(
      userId: json['userId'],
      date: DateTime.parse(json['date']),
      image: image,
      // content: json['content'],
      // textEmotion: List<String>.from(json['textEmotion']),
      // speechEmotion: List<String>.from(json['speechEmotion']),
      // charCount: json['charCount'],
    );
  }
}
