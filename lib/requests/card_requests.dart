import 'dart:convert';

import 'package:client/dto/account_requisites.dart';
import 'package:client/dto/transfer.dart';
import 'package:client/exceptions/auth_errors.dart';
import 'package:http/http.dart' as http;

import '../dto/debit_card.dart';
import '../vars/request_vars.dart';

Future<List<DebitCard>> getDebitCards(
    String accessToken, int skip, int limit) async {
  var uri =
      "$protocol://$appServerAddress/individuals/me/debit_cards?skip=$skip&limit=$limit";

  var response = await http.get(
    Uri.parse(uri),
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $accessToken"
    },
  );

  switch (response.statusCode) {
    case 200:
      Iterable l = json.decode(response.body);
      List<DebitCard> cards =
          List<DebitCard>.from(l.map((e) => DebitCard.fromJson(e)));
      return cards;
    case 401:
      throw NoAuthException("Пользователь не авторизован.");
    case 403:
      throw ForbiddenException("Нет прав.");
    default:
      throw Exception(response.reasonPhrase);
  }
}

Future<AccountRequisites> getAccountRequisitesByCardNumber(
    String accessToken, String cardNumber) async {
  var uri =
      "$protocol://$appServerAddress/individuals/me/debit_cards/$cardNumber/account_requisites";

  var response = await http.get(
    Uri.parse(uri),
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $accessToken"
    },
  );

  switch (response.statusCode) {
    case 200:
      return AccountRequisites.fromJson(json.decode(response.body));
    case 401:
      throw NoAuthException("Пользователь не авторизован.");
    case 403:
      throw ForbiddenException("Нет прав.");
    default:
      throw Exception(response.reasonPhrase);
  }
}


Future<List<Transfer>> getAllTransfersByCardNumber(
    String accessToken, String cardNumber, int skip, int limit) async {
  var uri =
      "$protocol://$appServerAddress/debit_cards/$cardNumber/account_operations?skip=$skip&limit=$limit";
  
  print(uri);

  var response = await http.get(
    Uri.parse(uri),
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $accessToken"
    },
  );

  switch (response.statusCode) {
    case 200:

      Iterable l = json.decode(response.body);
      List<Transfer> transfers =
      List<Transfer>.from(l.map((e) => Transfer.fromJson(e)));
      return transfers;
    case 401:
      throw NoAuthException("Пользователь не авторизован.");
    case 403:
      throw ForbiddenException("Нет прав.");
    default:
      throw Exception(response.reasonPhrase);
  }
}



Future<List<String>> getAllCardNumbersByUserSub(String accessToken, String userSub) async {
  var uri =
      "$protocol://$appServerAddress/debit_cards/search/$userSub";


  print(uri);

  var response = await http.get(
    Uri.parse(uri),
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $accessToken"
    },
  );

  switch (response.statusCode) {
    case 200:

      Iterable l = json.decode(response.body);
      List<String> cardNumbers = List<String>.from(l);
      return cardNumbers;
    case 401:
      throw NoAuthException("Пользователь не авторизован.");
    case 403:
      throw ForbiddenException("Нет прав.");
    default:
      throw Exception(response.reasonPhrase);
  }
}