// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
    };

KakaoAuthCode _$KakaoAuthCodeFromJson(Map<String, dynamic> json) =>
    KakaoAuthCode(
      code: json['code'] as String,
    );

Map<String, dynamic> _$KakaoAuthCodeToJson(KakaoAuthCode instance) =>
    <String, dynamic>{
      'code': instance.code,
    };
