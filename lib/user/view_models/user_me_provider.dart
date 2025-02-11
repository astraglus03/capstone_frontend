import 'package:capstone_frontend/common/const/const.dart';
import 'package:capstone_frontend/common/secure_storage/secure_storage.dart';
import 'package:capstone_frontend/user/models/user_model.dart';
import 'package:capstone_frontend/user/repository/auth_repository.dart';
import 'package:capstone_frontend/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final userMeProvider = StateNotifierProvider<UserMeStateNotifier, UserModelBase?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userMeRepository = ref.watch(userMeRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);

  return UserMeStateNotifier(
    authRepository: authRepository,
    repository: userMeRepository,
    storage: storage,
  );
});

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserMeRepository repository;
  final FlutterSecureStorage storage;

  UserMeStateNotifier({
    required this.authRepository,
    required this.repository,
    required this.storage,
  }) : super(UserModelLoading()) {
    getMe();
  }

  Future<void> getMe() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    if (refreshToken == null || accessToken == null) {
      state = null;
      return;
    }

    try {
      // 실제 서버 연동 코드 (현재는 주석 처리)
      /*
      final resp = await repository.getMe();
      state = resp;
      */

      // 카카오 사용자 정보 직접 사용 (서버 연동 전까지 사용)
      final userInfo = await getKakaoUserInfo();
      state = userInfo;
    } catch (e) {
      print('사용자 정보 조회 실패: $e');
      state = UserModelError(message: '사용자 정보를 가져오는데 실패했습니다.');
    }
  }

  Future<void> loginWithKakao() async {
    state = UserModelLoading();
    
    try {
      // 1. 카카오 인증 코드 받기
      final kakaoAuthCode = await authRepository.getKakaoAuthCode();
      if (kakaoAuthCode == null) {
        state = UserModelError(message: '카카오 로그인에 실패했습니다.');
        return;
      }

      // 2. 서버에 인증 코드 전송하고 JWT 토큰 받기
      final authResp = await authRepository.authenticateWithKakao(kakaoAuthCode);
      
      // 3. 토큰 저장
      await storage.write(key: ACCESS_TOKEN_KEY, value: authResp.accessToken);
      await storage.write(key: REFRESH_TOKEN_KEY, value: authResp.refreshToken);

      // 4. 사용자 정보 가져오기
      await getMe();
    } catch (e) {
      print('로그인 실패: $e');
      state = UserModelError(message: '로그인에 실패했습니다.');
    }
  }

  Future<void> logout() async {
    try {
      await authRepository.logout();
      await Future.wait([
        storage.delete(key: ACCESS_TOKEN_KEY),
        storage.delete(key: REFRESH_TOKEN_KEY),
      ]);
      state = null;
    } catch (e) {
      print('로그아웃 실패: $e');
    }
  }
}
