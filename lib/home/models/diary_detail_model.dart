import 'package:capstone_frontend/home/models/diary_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'diary_detail_model.g.dart';

@JsonSerializable()
class DiaryDetailModel extends DiaryModel {
  final List<EmotionChange>? emotionChanges;  // 감정 변화 기록
  final String? overallFeedback;        // 전체 감정 변화에 대한 피드백

  DiaryDetailModel({
    super.id,
    super.date,
    super.image,
    super.content,
    super.feedback,
    super.absEmotion,
    this.emotionChanges,
    this.overallFeedback,
  });

  factory DiaryDetailModel.fromJson(Map<String, dynamic> json) => _$DiaryDetailModelFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$DiaryDetailModelToJson(this);
}

@JsonSerializable()
class EmotionChange {
  final String fromEmotion;
  final String toEmotion;
  final String changeComment;
  final int index;

  EmotionChange({
    required this.fromEmotion,
    required this.toEmotion,
    required this.changeComment,
    required this.index,
  });

  factory EmotionChange.fromJson(Map<String, dynamic> json) => _$EmotionChangeFromJson(json);
  Map<String, dynamic> toJson() => _$EmotionChangeToJson(this);
}
