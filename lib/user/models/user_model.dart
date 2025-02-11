import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

abstract class UserModelBase {}

class UserModelError extends UserModelBase {
  final String message;

  UserModelError({
    required this.message,
  });
}

class UserModelLoading extends UserModelBase {}

@JsonSerializable()
class UserModel extends UserModelBase {
  final String id;
  final String name;
  final String email;
  @JsonKey(name: 'profile_image')
  final String? profileImage;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
