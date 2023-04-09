import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../dto/keycloak_auth.dart';
import '../utils/jwt.dart';
import '../vars/request_vars.dart';

class KeycloakAuth {
  static String? _accessToken;
  static String? _refreshToken;
  static AccessTokenJWTContext? _accessTokenContext;
  static JwtContext? _refreshTokenContext;

  static Future<String?> getAccessToken() async {
    if (_accessToken == null) {
      final prefs = await SharedPreferences.getInstance();
      _accessToken = prefs.getString("accessToken");
    }

    if (_accessToken == null) {
      return null;
    }

    _accessTokenContext =
        AccessTokenJWTContext.fromJson(parseJwt(_accessToken!));

    if (_accessTokenContext!.exp * 1000 <
        DateTime.now().millisecondsSinceEpoch) {
      final prefs = await SharedPreferences.getInstance();

      _refreshToken ??= prefs.getString("refreshToken");

      if (_refreshToken == null) {
        return null;
      }

      _refreshTokenContext = JwtContext.fromJson(parseJwt(_refreshToken!));

      if (_refreshTokenContext!.exp * 1000 <
          DateTime.now().millisecondsSinceEpoch) {
        clear();
        return null;
      }
      var refreshToken = await _getAccessTokenByRefreshToken();
      return refreshToken;
    }

    return _accessToken;
  }

  static AccessTokenJWTContext? getAccessTokenContext() {
    return _accessTokenContext;
  }

  static clear() {
    _accessToken = null;
    _refreshToken = null;
    _accessTokenContext = null;
    _refreshTokenContext = null;
  }

  static Future<String> _getAccessTokenByRefreshToken() async {
    var loginForm = {
      'client_id': clientId,
      'grant_type': "refresh_token",
      'scope': scope,
      'refresh_token': _refreshToken
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
        var ka = KeycloakAuthDto.fromJson(json.decode(response.body));
        _saveAuth(ka);
        return ka.accessToken;
      default:
        throw Exception(response.reasonPhrase);
    }
  }

  static void _saveAuth(KeycloakAuthDto ka) async {
    _accessToken = ka.accessToken;
    _refreshToken = ka.refreshToken;
    _accessTokenContext =
        AccessTokenJWTContext.fromJson(parseJwt(_accessToken!));
    _refreshTokenContext = JwtContext.fromJson(parseJwt(_refreshToken!));

    final prefs = await SharedPreferences.getInstance();

    prefs.setString("accessToken", _accessToken!);
    prefs.setString("refreshToken", _refreshToken!);
  }

  static Future<String?> logIn(String login, String password) async {
    var loginForm = {
      'client_id': clientId,
      'grant_type': "password",
      'scope': scope,
      'username': login,
      'password': password
    };

    var response = http
        .post(
      Uri.parse(
          "http://$keycloakServerAddress/realms/bank-app/protocol/openid-connect/token"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: loginForm,
    )
        .then((response) {
      switch (response.statusCode) {
        case 200:
          _saveAuth(KeycloakAuthDto.fromJson(jsonDecode(response.body)));
          return null;
        case 401:
          return "Неверный логин или пароль";
        default:
          return response.reasonPhrase;
      }
    }).onError((error, stackTrace) => error.toString());
    return response;
  }
}
