// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoiceModel _$VoiceModelFromJson(Map<String, dynamic> json) => VoiceModel(
      index: (json['index'] as num).toInt(),
      sentence: json['sentence'] as String,
    );

Map<String, dynamic> _$VoiceModelToJson(VoiceModel instance) =>
    <String, dynamic>{
      'index': instance.index,
      'sentence': instance.sentence,
    };

VoiceResponse _$VoiceResponseFromJson(Map<String, dynamic> json) =>
    VoiceResponse(
      isRegistered: json['isRegistered'] as bool,
    );

Map<String, dynamic> _$VoiceResponseToJson(VoiceResponse instance) =>
    <String, dynamic>{
      'isRegistered': instance.isRegistered,
    };
