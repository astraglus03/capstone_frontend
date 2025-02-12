
import 'package:json_annotation/json_annotation.dart';

part 'month_feedback_model.g.dart';

@JsonSerializable()
class MonthFeedbackModel{
  final String feedback;

  MonthFeedbackModel({
    required this.feedback,
  });
  factory MonthFeedbackModel.fromJson(Map<String,dynamic> json)
  => _$MonthFeedbackModelFromJson(json);
}