import 'dart:convert';

import 'package:client/dto/product_order.dart';
import 'package:client/exceptions/auth_errors.dart';
import 'package:http/http.dart' as http;

import '../vars/request_vars.dart';

const productOrderUri = "http://$appServerAddress/product_orders/";

Future<List<ProductOrder>> getProductOrders(
    String accessToken, int skip, int limit) async {
  var uri =
      "http://$appServerAddress/individuals/me/product_orders?skip=$skip&limit=$limit";

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

      List<ProductOrder> orders =
          List<ProductOrder>.from(l.map((e) => ProductOrder.fromJson(e)));

      return orders;
    case 401:
      throw Exception("Пользователь не авторизован.");
    case 403:
      throw Exception("Нет прав.");
    default:
      throw Exception(response.reasonPhrase);
  }
}

Future<bool> createProductOrder(
    String accessToken, ProductOrder productOrder) async {
  var uri = "http://$appServerAddress/product_orders";

  var response = await http.post(Uri.parse(uri),
      headers: {
        "Accept": "application/json",
        'Content-Type': 'application/json',
        "Authorization": "Bearer $accessToken}"
      },
      body: jsonEncode(productOrder));

  switch (response.statusCode) {
    case 200:
      return true;
    case 401:
      throw NoAuthException("Пользователь не авторизован.");
    case 403:
      throw Exception("Нет прав.");
    default:
      throw Exception(response.reasonPhrase);
  }
}
