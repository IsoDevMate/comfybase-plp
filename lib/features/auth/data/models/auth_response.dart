// auth_response.dart
import 'package:json_annotation/json_annotation.dart';
import '../../../../core/models/user_model.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  final UserModel user;
  final TokensModel tokens;

  const AuthResponse({required this.user, required this.tokens});

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

@JsonSerializable()
class TokensModel {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  const TokensModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory TokensModel.fromJson(Map<String, dynamic> json) =>
      _$TokensModelFromJson(json);
  Map<String, dynamic> toJson() => _$TokensModelToJson(this);
}
