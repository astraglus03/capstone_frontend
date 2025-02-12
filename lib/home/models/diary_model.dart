import 'dart:convert';
import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';

part 'diary_model.g.dart';

@JsonSerializable()
class DiaryModel {
  final String? id;
  final DateTime? date;
  final String? content;
  final String? feedback;
  final List<String>? absEmotion;  // 감정 리스트
  
  @JsonKey(
    fromJson: _imageFromJson,
    toJson: _imageToJson,
    includeIfNull: false,
  )
  final Uint8List? image;

  DiaryModel({
    this.id,
    this.date,
    this.content,
    this.feedback,
    this.absEmotion,
    this.image,
  });

  factory DiaryModel.fromJson(Map<String, dynamic> json) => _$DiaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$DiaryModelToJson(this);

  static Uint8List? _imageFromJson(String? json) {
    if (json == null) return null;
    try {
      return base64Decode(json);
    } catch (e) {
      print('Error decoding image: $e');
      return null;
    }
  }

  static String? _imageToJson(Uint8List? image) {
    if (image == null) return null;
    try {
      return base64Encode(image);
    } catch (e) {
      print('Error encoding image: $e');
      return null;
    }
  }
}
