import 'package:capstone_frontend/common/const/const.dart';
import 'package:capstone_frontend/common/secure_storage/secure_storage.dart';
import 'package:capstone_frontend/user/models/auth_response.dart';
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
      final resp = await repository.getMe();
      state = resp;
    } catch (e) {
      print('Get Me Error: $e');
      state = UserModelError(message: '사용자 정보를 가져오는데 실패했습니다.');
    }
  }

  Future<void> loginWithKakao() async {
    state = UserModelLoading();

    try {
      // 1. 카카오톡으로부터 인가코드 수령
      final kakaoAuthCode = await authRepository.getKakaoAuthCode();
      if (kakaoAuthCode == null) {
        state = UserModelError(message: '카카오 로그인에 실패했습니다.');
        return;
      }

      // 2. JWT토큰으로 변경.
      final authResp = await authRepository.authenticateWithKakao(kakaoAuthCode);

      await storage.write(key: ACCESS_TOKEN_KEY, value: authResp.accessToken);
      await storage.write(key: REFRESH_TOKEN_KEY, value: authResp.refreshToken);


      final userResp = await repository.getMe();
      state = userResp;
    } catch (e) {
      print('로그인 Error: $e');
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
      print('Logout Error: $e');
    }
  }
}
