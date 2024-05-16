class DiaryMonthModel {
  final List<int> textCount;
  final List<int> speechCount;
  final List<int> absTextCount;
  final List<String> representEmotion;

  DiaryMonthModel({
    required this.textCount,
    required this.speechCount,
    required this.absTextCount,
    required this.representEmotion,
  });

  factory DiaryMonthModel.fromJson(Map<String, dynamic> json) {
    return DiaryMonthModel(
      textCount: List<int>.from(json['textCount'] ?? []),
      speechCount: List<int>.from(json['speechCount'] ?? []),
      absTextCount: List<int>.from(json['absTextCount'] ?? []),
      representEmotion: List<String>.from(json['month_max_emotion'] ?? []),
    );
  }
}
