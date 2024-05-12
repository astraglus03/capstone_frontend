import 'dart:convert';
import 'dart:typed_data';

import 'package:capstone_frontend/screen/statistic/model/photo_model.dart';

class PhotoDetailModel{
  final String? content;
  final List<String>? textEmotion;
  final List<String>? speechEmotion;
  final String? charCount;
  final String? userId;
  final DateTime? date;
  final Uint8List? image;

  PhotoDetailModel({
     this.content,
     this.textEmotion,
     this.speechEmotion,
     this.charCount,
     this.userId,
     this.date,
     this.image,
  });

  factory PhotoDetailModel.fromJson(Map<String, dynamic> json) {
    String base64String = json['image'];
    Uint8List image = base64Decode(base64String);
    return PhotoDetailModel(
      // userId: baseModel.userId,
      // date: baseModel.date,
      // image: baseModel.image,
      userId: json['userId'],
      date: DateTime.parse(json['date']),
      image: image,
      content: json['content']?? '',
      textEmotion: List<String>.from(json['textEmotion']),
      speechEmotion: List<String>.from(json['speechEmotion']),
      charCount: json['charCount'] ?? '',
    );
  }
}