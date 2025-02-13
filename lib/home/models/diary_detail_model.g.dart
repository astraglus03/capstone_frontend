// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryDetailModel _$DiaryDetailModelFromJson(Map<String, dynamic> json) =>
    DiaryDetailModel(
      id: json['id'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      image: DiaryModel.imageFromJson(json['image'] as String?),
      content: json['content'] as String?,
      feedback: json['feedback'] as String?,
      absEmotion: (json['absEmotion'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      emotionChanges: (json['emotionChanges'] as List<dynamic>?)
          ?.map((e) => EmotionChange.fromJson(e as Map<String, dynamic>))
          .toList(),
      overallFeedback: json['overallFeedback'] as String?,
    );

Map<String, dynamic> _$DiaryDetailModelToJson(DiaryDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date?.toIso8601String(),
      'content': instance.content,
      'feedback': instance.feedback,
      'absEmotion': instance.absEmotion,
      if (DiaryModel.imageToJson(instance.image) case final value?)
        'image': value,
      'emotionChanges': instance.emotionChanges,
      'overallFeedback': instance.overallFeedback,
    };

EmotionChange _$EmotionChangeFromJson(Map<String, dynamic> json) =>
    EmotionChange(
      fromEmotion: json['fromEmotion'] as String,
      toEmotion: json['toEmotion'] as String,
      changeComment: json['changeComment'] as String,
      index: (json['index'] as num).toInt(),
    );

Map<String, dynamic> _$EmotionChangeToJson(EmotionChange instance) =>
    <String, dynamic>{
      'fromEmotion': instance.fromEmotion,
      'toEmotion': instance.toEmotion,
      'changeComment': instance.changeComment,
      'index': instance.index,
    };
