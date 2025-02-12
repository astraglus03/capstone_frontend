import 'package:json_annotation/json_annotation.dart';

part 'month_emotion_resp_model.g.dart';

@JsonSerializable()
class DiaryMonthModel {
  final List<int> textCount;
  final List<int> speechCount;
  final List<int> absTextCount;
  final List<String> representEmotion;
  final List cases;
  final String sendComment;
  final List<int> eventCount;
  final String monthFeedback;

  DiaryMonthModel({
    required this.textCount,
    required this.speechCount,
    required this.absTextCount,
    required this.representEmotion,
    required this.cases,
    required this.sendComment,
    required this.eventCount,
    required this.monthFeedback,
  });

  factory DiaryMonthModel.fromJson(Map<String, dynamic> json) => _$DiaryMonthModelFromJson(json);
  Map<String, dynamic> toJson() => _$DiaryMonthModelToJson(this);
}
