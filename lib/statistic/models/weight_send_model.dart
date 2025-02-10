import 'dart:io';

class WeightSendModel {
  final String userId;
  final File voice1;
  final File voice2;
  final File voice3;
  final File voice4;
  final File voice5;

  WeightSendModel({
    required this.userId,
    required this.voice1,
    required this.voice2,
    required this.voice3,
    required this.voice4,
    required this.voice5,
  });

  factory WeightSendModel.fromJson(Map<String, dynamic> json){

    return WeightSendModel(
      userId: json['userId'],
      voice1: json['voice1'],
      voice2: json['voice2'],
      voice3: json['voice3'],
      voice4: json['voice4'],
      voice5: json['voice5'],
    );
  }
}
