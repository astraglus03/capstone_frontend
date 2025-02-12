// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'month_emotion_resp_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryMonthModel _$DiaryMonthModelFromJson(Map<String, dynamic> json) =>
    DiaryMonthModel(
      textCount: (json['textCount'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      speechCount: (json['speechCount'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      absTextCount: (json['absTextCount'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      representEmotion: (json['representEmotion'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      cases: json['cases'] as List<dynamic>,
      sendComment: json['sendComment'] as String,
      eventCount: (json['eventCount'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      monthFeedback: json['monthFeedback'] as String,
    );

Map<String, dynamic> _$DiaryMonthModelToJson(DiaryMonthModel instance) =>
    <String, dynamic>{
      'textCount': instance.textCount,
      'speechCount': instance.speechCount,
      'absTextCount': instance.absTextCount,
      'representEmotion': instance.representEmotion,
      'cases': instance.cases,
      'sendComment': instance.sendComment,
      'eventCount': instance.eventCount,
      'monthFeedback': instance.monthFeedback,
    };
