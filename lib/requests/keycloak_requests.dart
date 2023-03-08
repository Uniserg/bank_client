import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../dto/keycloak_auth.dart';
import '../utils/jwt.dart';
import '../vars/request_vars.dart';
import '../vars/session_vars.dart';

void saveAuth(String body) async {
  var authResponse = jsonDecode(body);
  accessToken = authResponse['access_token'];
  refreshToken = authResponse['refresh_token'];

  final prefs = await SharedPreferences.getInstance();

  await prefs.setString("accessToken", accessToken!);
  await prefs.setString("refreshToken", refreshToken!);

  accessTokenContext = AccessTokenJWTContext.fromJson(parseJwt(accessToken!));
  refreshTokenContext = JwtContext.fromJson(parseJwt(accessToken!));
}

Future<String?> logIn(String login, String password) async {
  var loginForm = {
    'client_id': clientId,
    'grant_type': "password",
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
      saveAuth(response.body);

      return null;
    case 401:
      return "Неверный логин или пароль";
    default:
      throw Exception(response.reasonPhrase);
  }
}

Future<String?> logInWithRefreshToken() async {
  final prefs = await SharedPreferences.getInstance();
  refreshToken = prefs.getString("refreshToken");
  refreshTokenContext = JwtContext.fromJson(parseJwt(accessToken!));

  if (refreshTokenContext!.exp < DateTime.now().microsecondsSinceEpoch) {
    throw Exception("Auth timeout");
    // TODO: сделать как ошибку
    return "Auth timeout";
  }

  var loginForm = {
    'client_id': clientId,
    'grant_type': "refresh_token",
    'scope': scope,
    'refresh_token': refreshToken
  };

  var response = await http.post(
      Uri.parse(
          "http://$keycloakServerAddress/realms/bank-app/protocol/openid-connect/token"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      encoding: Encoding.getByName("utf-8"),
      body: loginForm);

  switch (response.statusCode) {
    case 200:
      saveAuth(response.body);
      return null;
    default:
      throw Exception(response.reasonPhrase);
  }
}
