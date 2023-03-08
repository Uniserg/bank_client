import 'package:json_annotation/json_annotation.dart';

part 'keycloak_auth.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccessTokenJWTContext extends JwtContext {
  // String sub;
  // int exp;
  // int iat;
  // String jti;
  // String sid;
  // String name;
  // String email;
  @JsonKey(name: "family_name")
  String lastName;
  @JsonKey(name: "given_name")
  String firstName;

  AccessTokenJWTContext(
      {required super.sub,
      required super.exp,
      required super.iat,
      required super.jti,
      required super.sid,
      required this.lastName,
      required this.firstName});

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

class KeycloakAuth {
  String accessToken;
  String refreshToken;
  int refreshExp;
  AccessTokenJWTContext accessTokenContext;

  KeycloakAuth(
      {required this.accessToken,
      required this.accessTokenContext,
      required this.refreshToken,
      required this.refreshExp});
}
