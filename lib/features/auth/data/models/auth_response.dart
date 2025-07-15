import 'package:json_annotation/json_annotation.dart';
import '../../../../core/models/user_model.dart';
import 'tokens.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  final UserModel user;
  final Tokens tokens;

  AuthResponse({required this.user, required this.tokens});

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
