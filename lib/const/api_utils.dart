import 'dart:async';
import 'dart:convert';
import 'package:capstone_frontend/const/currentuser_model.dart';
import 'package:http/http.dart' as http;

String ip = 'http://3.34.199.26:5000';

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

Future<CurrentUser?> checkCurrentUser(String userId) async {
    try {
      final resp = await http.get(Uri.parse('$ip/userinfo/userinfo/$userId'));
      if (resp.statusCode == 200) {
        var data = jsonDecode(resp.body);
        return CurrentUser.fromJson(data);
        // print("사용자 ID: ${data['userId']}");
        // print("닉네임: ${data['nickname']}");
        // print("프로필 이미지 URL: ${data['profileImage']}");
      } else {
        throw Exception('서버에서 정보를 가져오는 데 실패했습니다.');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
}
// String? userId = UserManager().getUserId();


