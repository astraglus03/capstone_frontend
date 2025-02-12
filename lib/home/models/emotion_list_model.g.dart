// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmotionListModel _$EmotionListModelFromJson(Map<String, dynamic> json) =>
    EmotionListModel(
      emotionList: (json['emotionList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$EmotionListModelToJson(EmotionListModel instance) =>
    <String, dynamic>{
      'emotionList': instance.emotionList,
    };
