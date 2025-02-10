import 'dart:async';

class UserManager {
  static final UserManager _instance = UserManager._internal();

  factory UserManager() => _instance;

  final _userIdController = StreamController<String>.broadcast();
  String? _userId;

  UserManager._internal();

  Stream<String> get userIdStream => _userIdController.stream;

  void setUserId(String userId) {
    _userId = userId;
    _userIdController.add(userId);
  }

  String? getUserId() => _userId;

  void dispose() {
    _userIdController.close();
  }
}