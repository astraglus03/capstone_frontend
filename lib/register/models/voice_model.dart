import 'dart:io';
import 'package:json_annotation/json_annotation.dart';

part 'voice_model.g.dart';

@JsonSerializable()
class VoiceModel {
  @JsonKey(ignore: true)
  final File? audioFile;
  final int index;
  final String sentence;

  VoiceModel({
    this.audioFile,
    required this.index,
    required this.sentence,
  });

  factory VoiceModel.fromJson(Map<String, dynamic> json) {
    return _$VoiceModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$VoiceModelToJson(this);
}


@JsonSerializable()
class VoiceResponse {
  final bool isRegistered;
  
  VoiceResponse({
    required this.isRegistered,
  });

  factory VoiceResponse.fromJson(Map<String, dynamic> json) => _$VoiceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VoiceResponseToJson(this);
}

// 샘플 문장 리스트
class VoiceSamples {
  static const List<String> sentences = [
    "오늘 달리기 대회에서 1등 했어!",
    "친구가 맛있는거 사줘서 기분이 좋아!",
    "부모님이 생일선물로 자전거를 선물해줬어",
    "오늘은 친구들과 함께 놀이공원에 갔어!",
    "퐁당이 어플을 만나서 행복해."
  ];
} 