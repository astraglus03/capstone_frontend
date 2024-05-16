class MonthEmotionSendModel {
  final String month;
  final String userId;

  MonthEmotionSendModel({
    required this.month,
    required this.userId,
  });

  factory MonthEmotionSendModel.fromJson(Map<String, dynamic> json) {
    return MonthEmotionSendModel(
      month: json['month'],
      userId: json['userId'],
    );
  }
}