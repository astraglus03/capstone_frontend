import 'dart:io';

class MonthFeedbackModel{
  final String feedback;

  MonthFeedbackModel({
    required this.feedback,
  });
  factory MonthFeedbackModel.fromJson(Map<String, dynamic> json) {
    return MonthFeedbackModel(
      feedback: json['feedback'],
    );
  }
}