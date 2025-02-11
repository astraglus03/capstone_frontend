import 'dart:io';

import 'package:capstone_frontend/common/const/const.dart';
import 'package:capstone_frontend/common/dio/dio.dart';
import 'package:capstone_frontend/register/models/voice_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'voice_repository.g.dart';

final voiceRepositoryProvider = Provider<VoiceRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return VoiceRepository(dio, baseUrl: 'http://$ip/register');
});

@RestApi()
abstract class VoiceRepository {
  factory VoiceRepository(Dio dio, {String baseUrl}) = _VoiceRepository;

  // 음성 등록 여부 확인
  @GET('/voice/status')
  @Headers({
    'accessToken': 'true',
  })
  Future<VoiceResponse> checkVoiceStatus();

  // 음성 등록
  @POST('/voice')
  @Headers({
    'accessToken': 'true',
  })
  @MultiPart()
  Future<VoiceResponse> registerVoice({
    @Part(name: 'file') required File audioFile,
    @Part(name: 'index') required int index,
    @Part(name: 'sentence') required String sentence,
  });
} 