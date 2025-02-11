import 'dart:convert';
import 'package:capstone_frontend/common/const/const.dart';
import 'package:capstone_frontend/user/social_api/auth_api.dart';
import 'package:capstone_frontend/user/social_api/social_login.dart';
import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

final dio = Dio();

class KakaoLogin implements SocialLogin {
  @override
  Future<bool> login() async {
    try {
      var loginResult = await (await isKakaoTalkInstalled()
          ? UserApi.instance.loginWithKakaoTalk()
          : UserApi.instance.loginWithKakaoAccount());
      var user = await UserApi.instance.me();
      UserManager().setUserId(user.id.toString());
      return await _sendUserInfoToServer(user);
    } catch (e) {
      return false;
    }
  }

  Future<bool> _sendUserInfoToServer(User user) async {
    var url = '$ip/login/receive_user_info';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'userId': user.id.toString(),
      'nickname': user.kakaoAccount?.profile?.nickname ?? '',
      'profileImage': user.kakaoAccount?.profile?.profileImageUrl ?? ''
    });

    var resp = await dio.post(url,data: body);
    if (resp.statusCode == 200) {
      print('User info sent to server successfully.');
      return true;
    } else {
      print('Failed to send user info to server. Status code: ${resp.statusCode}');
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      UserManager().setUserId('');
      return true;
    } catch (error) {
      return false;
    }
  }
}