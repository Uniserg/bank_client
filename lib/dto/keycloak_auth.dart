import 'package:json_annotation/json_annotation.dart';

part 'keycloak_auth.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccessTokenJWTContext extends JwtContext {
  @JsonKey(name: "family_name")
  String lastName;
  @JsonKey(name: "given_name")
  String firstName;
  String email;
  @JsonKey(name: "preferred_username")
  String login;

  AccessTokenJWTContext({
    required super.sub,
    required super.exp,
    required super.iat,
    required super.jti,
    required super.sid,
    required this.lastName,
    required this.firstName,
    required this.email,
    required this.login,
  });

  factory AccessTokenJWTContext.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenJWTContextFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class JwtContext {
  String sub;
  int exp;
  int iat;
  String jti;
  String sid;

  JwtContext(
      {required this.sub,
      required this.exp,
      required this.iat,
      required this.jti,
      required this.sid});

  factory JwtContext.fromJson(Map<String, dynamic> json) =>
      _$JwtContextFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class KeycloakAuthDto {
  final String accessToken;
  final String refreshToken;

  KeycloakAuthDto({required this.accessToken, required this.refreshToken});

  factory KeycloakAuthDto.fromJson(Map<String, dynamic> json) =>
      _$KeycloakAuthDtoFromJson(json);
}
