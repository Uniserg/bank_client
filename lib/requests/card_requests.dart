import 'dart:convert';

import 'package:http/http.dart' as http;

import '../dto/debit_card.dart';
import '../vars/request_vars.dart';
import '../vars/session_vars.dart';

Future<List<DebitCard>> getDebitCards(int skip, int limit) async {
  var uri =
      "http://$appServerAddress/individuals/${accessTokenContext!.sub}/debit_cards?skip=$skip&limit=$limit";

  print(uri);

  var response = await http.get(
    Uri.parse(uri),
    headers: {
      "Accept": "application/json",
    },
  );

  switch (response.statusCode) {
    case 200:
      Iterable l = json.decode(response.body);

      print(response.body);

      List<DebitCard> cards =
          List<DebitCard>.from(l.map((e) => DebitCard.fromJson(e)));
      return cards;
    case 401:
      throw Exception("Пользователь не авторизован.");
    case 403:
      throw Exception("Нет прав.");
    default:
      throw Exception(response.reasonPhrase);
  }
}
