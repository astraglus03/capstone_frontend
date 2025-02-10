class CurrentUser {
  final String userId;
  final String nickname;
  final String imageUrl;
  final double weight;

  CurrentUser({required this.userId, required this.nickname, required this.imageUrl, required this.weight});

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    return CurrentUser(
      userId: json['userId'],
      nickname: json['nickname'],
      imageUrl: json['profileImage'],
      weight: json['weight'],
    );
  }
}