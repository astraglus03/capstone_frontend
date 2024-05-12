// API 모델 역할
class DiaryItem {
  final String userId;
  final String date;
  final String content;
  final List textEmotion;
  final List speechEmotion;
  final int chatCount;

  DiaryItem({
    required this.userId,
    required this.date,
    required this.content,
    required this.textEmotion,
    required this.speechEmotion,
    required this.chatCount,
  });

  factory DiaryItem.fromJson(Map<String, dynamic> json) {
    return DiaryItem(
      userId: json['userId'],
      date: json['date'],
      content: json['content'],
      textEmotion: json['textEmotion'] is List ? json['textEmotion'] : [],
      speechEmotion: json['speechEmotion'] ?? '',
      chatCount: json['chatCount'] is int ? json['chatCount'] : 0,
    );
  }
}