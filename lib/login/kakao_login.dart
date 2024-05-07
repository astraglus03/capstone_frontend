import 'dart:convert';
import 'package:capstone_frontend/const/ip.dart';
import 'package:capstone_frontend/login/social_login.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLogin implements SocialLogin {
  @override
  Future<bool> login() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled(); //카카오톡이 설치 되었는지 확인
      if (isInstalled) {
        try {
          await UserApi.instance.loginWithKakaoTalk();
          var user = await UserApi.instance.me(); // 사용자 정보 가져오기
          await _sendUserInfoToServer(user); //서버에 유저 정보 보내기
          return true;
        } catch (e) {
          return false;
        }
      } else {
        try {
          await UserApi.instance.loginWithKakaoAccount();
          var user = await UserApi.instance.me(); // 사용자 정보 가져오기
          UserManager().setUserId(user.id.toString());
          await _sendUserInfoToServer(user); // 서버에 유저 정보 보내기
          return true;
        } catch (e) {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> _sendUserInfoToServer(User user) async { //서버에 유저 정보 보내는 함수
    var url = '$ip/login/receive_user_info';
    var headers = {
      'Content-Type': 'application/json', // 요청의 컨텐츠 유형을 JSON으로 지정
    };
    var body = {
      'userId': user.id.toString(),
      'nickname': user.kakaoAccount?.profile?.nickname ?? '',
      'profileImage': user.kakaoAccount?.profile?.profileImageUrl ??''
    };

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('User info sent to server successfully.');
    } else {
      print('Failed to send user info to server. Status code: ${response.statusCode}');
    }
  }





  @override
  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink(); //로그아웃
      return true;
    } catch (error) { //실패할 경우 예외처리
      return false;
    }
  }
}
