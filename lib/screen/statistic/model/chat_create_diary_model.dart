import 'dart:io';

class CreateDiaryModel{
  final String message;

  CreateDiaryModel({
    required this.message,
  });
  factory CreateDiaryModel.fromJson(Map<String, dynamic> json) {
    return CreateDiaryModel(
      message: json['message'],
    );
  }
}