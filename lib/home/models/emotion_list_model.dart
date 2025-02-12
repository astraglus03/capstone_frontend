import 'package:json_annotation/json_annotation.dart';

part 'emotion_list_model.g.dart';

@JsonSerializable()
class EmotionListModel {
  List<String> emotionList;

  EmotionListModel({
    required this.emotionList,
  });
  factory EmotionListModel.fromJson(Map<String,dynamic> json)
  => _$EmotionListModelFromJson(json);
}
