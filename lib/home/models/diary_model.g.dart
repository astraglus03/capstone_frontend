// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryModel _$DiaryModelFromJson(Map<String, dynamic> json) => DiaryModel(
      id: json['id'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      content: json['content'] as String?,
      feedback: json['feedback'] as String?,
      absEmotion: (json['absEmotion'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      image: DiaryModel._imageFromJson(json['image'] as String?),
    );

Map<String, dynamic> _$DiaryModelToJson(DiaryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date?.toIso8601String(),
      'content': instance.content,
      'feedback': instance.feedback,
      'absEmotion': instance.absEmotion,
      if (DiaryModel._imageToJson(instance.image) case final value?)
        'image': value,
    };
