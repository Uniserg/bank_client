import 'dart:convert';

import 'package:client/dto/transfer.dart';
import 'package:http/http.dart' as http;

import '../vars/request_vars.dart';

Future<Transfer> createTransfer(String accessToken, Transfer transfer) async {
  var uri = "http://$appServerAddress/debit_cards/transfer";

  var response = await http.post(Uri.parse(uri),
      headers: {
        "Accept": "application/json",
        'Content-Type': 'application/json',
        "Authorization": "Bearer $accessToken"
      },
      body: json.encode(transfer));

  switch (response.statusCode) {
    case 200:
      return Transfer.fromJson(json.decode(response.body));
    case 401:
      throw Exception("Пользователь не авторизован.");
    case 403:
      throw Exception("Нет прав.");
    default:
      throw Exception(response.reasonPhrase);
  }
}
