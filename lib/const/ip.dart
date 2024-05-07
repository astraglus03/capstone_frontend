String ip = 'http://3.34.199.26:5000';

class UserManager {
  static final UserManager _instance = UserManager._internal();

  factory UserManager() => _instance;

  String? userId;

  UserManager._internal();

  void setUserId(String id) {
    userId = id;
  }

  String? getUserId() {
    return userId;
  }
}

// String? userId = UserManager().getUserId();