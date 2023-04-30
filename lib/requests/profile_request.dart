import 'dart:convert';

import 'package:client/dto/profile.dart';
import 'package:http/http.dart' as http;

import '../exceptions/auth_errors.dart';
import '../vars/request_vars.dart';

Future<Profile?> findProfileByPhoneNumber(String accessToken, String phoneNumber) async {
  var uri =
      "$protocol://$appServerAddress/individuals/search/phone/$phoneNumber";

  var response = await http.get(
    Uri.parse(uri),
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $accessToken"
    },
  );

  switch (response.statusCode) {
    case 200:
      return Profile.fromJson(jsonDecode(response.body));
    case 401:
      throw NoAuthException("Пользователь не авторизован.");
    case 404:
      throw Exception("Пользователь не найден");
    case 403:
      throw Exception("Нет прав.");
    default:
      throw Exception(response.reasonPhrase);
  }
}

Future<Profile?> findProfileByCardNumber(
    String accessToken, String cardNumber) async {
  var uri =
      "$protocol://$appServerAddress/individuals/search/card_number/$cardNumber";

  var response = await http.get(
    Uri.parse(uri),
    headers: {
      "Accept": "application/json",
      // 'Content-Type': 'application/json',
      "Authorization": "Bearer $accessToken}"
    },
  );

  switch (response.statusCode) {
    case 200:
      return Profile.fromJson(jsonDecode(response.body));
    case 401:
      throw NoAuthException("Пользователь не авторизован.");
    case 404:
      throw Exception("Пользователь не найден");
    case 403:
      throw Exception("Нет прав.");
    default:
      throw Exception(response.reasonPhrase);
  }
}
