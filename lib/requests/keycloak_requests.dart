import 'dart:convert';

import 'package:http/http.dart' as http;

import '../dto/keycloak_auth.dart';
import '../utils/jwt.dart';
import '../vars/request_vars.dart';
import '../vars/session_vars.dart';

KeycloakAuth getKeycloakAuth(String body) {
  var authResponse = jsonDecode(body);
  var accessToken = authResponse['access_token'];
  var refreshToken = authResponse['refresh_token'];

  AccessTokenJWTContext authContext =
      AccessTokenJWTContext.fromJson(parseJwt(accessToken));

  return KeycloakAuth(
      accessToken: accessToken,
      accessTokenContext: authContext,
      refreshToken: refreshToken,
      refreshExp: parseJwt(refreshToken)['exp']);
}

Future<String?> logIn(String login, String password) async {
  var loginForm = {
    'client_id': clientId,
    'grant_type': grantType,
    'scope': scope,
    'username': login,
    'password': password
  };

  print(json.encode(loginForm));

  var response = await http.post(
    Uri.parse(
        "http://$keycloakServerAddress/realms/bank-app/protocol/openid-connect/token"),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    },
    encoding: Encoding.getByName("utf-8"),
    body: loginForm,
  );

  switch (response.statusCode) {
    case 200:
      keycloakAuth = getKeycloakAuth(response.body);
      return null;
    case 401:
      return "Неверный логин или пароль";
    default:
      throw Exception(response.reasonPhrase);
  }
}

Future<String?> refreshToken() async {
  if (keycloakAuth!.refreshExp < DateTime.now().microsecondsSinceEpoch) {
    // TODO: сделать как ошибку
    return "Auth timeout";
  }

  var response = await http.post(
      Uri.parse(
          "http://$keycloakServerAddress/realms/bank-app/protocol/openid-connect/token"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      encoding: Encoding.getByName("utf-8"),
      body: keycloakAuth?.refreshToken);

  switch (response.statusCode) {
    case 200:
      keycloakAuth = getKeycloakAuth(response.body);
      return null;
    default:
      throw Exception(response.reasonPhrase);
  }
}
