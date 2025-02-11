import 'package:capstone_frontend/common/const/const.dart';
import 'package:capstone_frontend/common/dio/dio.dart';
import 'package:capstone_frontend/common/models/login_response.dart';
import 'package:capstone_frontend/user/models/auth_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';


final authRepositoryProvider = Provider<AuthRepository>((ref){
  final dio = ref.watch(dioProvider);
  return AuthRepository(baseUrl: 'http://$ip/auth', dio: dio);
});

class AuthRepository {
  final String baseUrl;
  final Dio dio;

  AuthRepository({
    required this.baseUrl,
    required this.dio,
  });

  Future<String?> getKakaoAuthCode() async {
    try {
      OAuthToken? token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      return token.accessToken;
    } catch (error) {
      print('카카오 인증 에러: $error');
      return null;
    }
  }

  // 카카오 인증 코드로 서버 인증 및 JWT 토큰 발급
  Future<AuthResponse> authenticateWithKakao(String kakaoAuthCode) async {
    final resp = await dio.post(
      '$baseUrl/kakao',
      data: {
        'code': kakaoAuthCode,
      },
    );

    return AuthResponse.fromJson(resp.data);
  }

  // 로그아웃
  Future<void> logout() async {
    try {
      await dio.post(
        '$baseUrl/logout',
        options: Options(
          headers: {
            'accessToken': 'true',
          },
        ),
      );
      await UserApi.instance.logout();
    } catch (e) {
      print('로그아웃 실패: $e');
    }
  }
}
