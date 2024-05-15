class QandARespModel {
  final String answer;

  QandARespModel({
    required this.answer,
  });

  factory QandARespModel.fromJson(Map<String, dynamic> json) {
    return QandARespModel(
      answer: json['answer'],
    );
  }
}