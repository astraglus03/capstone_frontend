import 'package:capstone_frontend/common/const/const.dart';
import 'package:capstone_frontend/common/dio/dio.dart';
import 'package:capstone_frontend/home/models/emotion_list_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';

part 'emotion_list_repository.g.dart';

final emotionRepositoryProvider = Provider<EmotionRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return EmotionRepository(dio, baseUrl: 'http://$ip/emotions');
});

@RestApi()
abstract class EmotionRepository {
  factory EmotionRepository(Dio dio, {String baseUrl}) = _EmotionRepository;

  @GET('/month/{yearMonth}')
  @Headers({
    'accessToken': 'true',
  })
  Future<EmotionListModel> getMonthBestEmotions({
    @Path() required String yearMonth,
  });

  // 임시 구현 (서버 연동 전까지 사용)
  static Future<EmotionListModel> getDummyEmotions() async {
    await Future.delayed(const Duration(seconds: 1)); // 로딩 시뮬레이션
    
    return EmotionListModel(
      emotionList: ['행복', '슬픔', '당황', '기쁨', '분노'],
    );
  }
}
