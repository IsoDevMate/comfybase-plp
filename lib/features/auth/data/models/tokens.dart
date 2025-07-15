import 'package:json_annotation/json_annotation.dart';

part 'tokens.g.dart';

@JsonSerializable()
class Tokens {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  Tokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory Tokens.fromJson(Map<String, dynamic> json) => _$TokensFromJson(json);
  Map<String, dynamic> toJson() => _$TokensToJson(this);
}
