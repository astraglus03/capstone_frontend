import 'package:capstone_frontend/common/const/const.dart';
import 'package:capstone_frontend/common/dio/dio.dart';
import 'package:capstone_frontend/user/models/auth_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
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

  // 카카오 로그인 및 인증 코드 받기
  Future<String?> getKakaoAuthCode() async {
    try {
      OAuthToken token;
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

  // 서버에 카카오 인증 코드 전송하고 JWT 토큰 받기
  Future<AuthResponse> authenticateWithKakao(String kakaoAuthCode) async {
    // 실제 서버 연동 코드 (현재는 주석 처리)
    /*
    final resp = await dio.post(
      '$baseUrl/kakao',
      data: {
        'code': kakaoAuthCode,
      },
    );
    return AuthResponse.fromJson(resp.data);
    */

    // 임시 JWT 토큰 생성 (서버 연동 전까지 사용)
    return AuthResponse(
      accessToken: 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  // 로그아웃
  Future<void> logout() async {
    try {
      // 실제 서버 연동 코드 (현재는 주석 처리)
      /*
      await dio.post(
        '$baseUrl/logout',
        options: Options(
          headers: {
            'accessToken': 'true',
          },
        ),
      );
      */

      // 카카오 로그아웃
      await UserApi.instance.logout();
    } catch (e) {
      print('로그아웃 실패: $e');
    }
  }
}
