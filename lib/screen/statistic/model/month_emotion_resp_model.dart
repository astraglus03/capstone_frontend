class DiaryMonthModel {
  final List<int> textCount;
  final List<int> speechCount;
  final List<int> absTextCount;
  final List<String> representEmotion;
  final List cases;
  final String sendComment;

  DiaryMonthModel({
    required this.textCount,
    required this.speechCount,
    required this.absTextCount,
    required this.representEmotion,
    required this.cases,
    required this.sendComment,
  });

  factory DiaryMonthModel.fromJson(Map<String, dynamic> json) {
    List cases = [];
    if(json['case1'] != null){
      cases.add(json['case1']);
    }
    if(json['case2'] != null){
      cases.add(json['case2']);
    }
    
    cases.addAll(List.from(json['cases'] ?? []));
    
    return DiaryMonthModel(
      textCount: List<int>.from(json['textCount'] ?? []),
      speechCount: List<int>.from(json['speechCount'] ?? []),
      absTextCount: List<int>.from(json['absTextCount'] ?? []),
      representEmotion: List<String>.from(json['month_max_emotion'] ?? []),
      cases: cases,
      sendComment: json['sendComment'] ?? '',
    );
  }
}
