class ScheduleRespModel{
  final String content;
  final String date;

  ScheduleRespModel({
    required this.content,
    required this.date,
  });
  factory ScheduleRespModel.fromJson(Map<String, dynamic> json) {
    return ScheduleRespModel(
      content: json['content'],
      date: json['date'],
    );
  }
}