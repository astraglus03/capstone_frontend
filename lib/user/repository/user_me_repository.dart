import 'package:capstone_frontend/common/const/const.dart';
import 'package:capstone_frontend/common/dio/dio.dart';
import 'package:capstone_frontend/user/models/user_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

part 'user_me_repository.g.dart';

final userMeRepositoryProvider = Provider<UserMeRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return UserMeRepository(dio, baseUrl: 'http://$ip/user/me');
});

@RestApi()
abstract class UserMeRepository {
  factory UserMeRepository(Dio dio, {String baseUrl}) = _UserMeRepository;

  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<UserModel> getMe();
}

// 카카오 사용자 정보를 UserModel로 변환 (서버 연동 전까지 사용)
Future<UserModel> getKakaoUserInfo() async {
  try {
    final User kakaoUser = await UserApi.instance.me();
    return UserModel(
      id: kakaoUser.id.toString(),
      name: kakaoUser.kakaoAccount?.profile?.nickname ?? 'Unknown',
      email: kakaoUser.kakaoAccount?.email ?? 'unknown@email.com',
      profileImage: kakaoUser.kakaoAccount?.profile?.profileImageUrl,
    );
  } catch (e) {
    throw Exception('카카오 사용자 정보 가져오기 실패: $e');
  }
}