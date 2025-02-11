import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

@JsonSerializable()
class KakaoAuthCode {
  final String code;

  KakaoAuthCode({
    required this.code,
  });

  factory KakaoAuthCode.fromJson(Map<String, dynamic> json) =>
      _$KakaoAuthCodeFromJson(json);
      
  Map<String, dynamic> toJson() => _$KakaoAuthCodeToJson(this);
}