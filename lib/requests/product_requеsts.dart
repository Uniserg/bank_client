import 'dart:convert';

import 'package:client/dto/product.dart';
import 'package:http/http.dart' as http;

import '../vars/request_vars.dart';

Future<List<Product>> getProducts(int skip, int limit) async {
  var uri = "$protocol://$appServerAddress/products";

  var response = await http.get(
    Uri.parse(uri),
    headers: {
      "Accept": "application/json",
    },
  );

  switch (response.statusCode) {
    case 200:
      Iterable l = json.decode(response.body);
      List<Product> products =
          List<Product>.from(l.map((e) => Product.fromJson(e)));
      return products;
    case 401:
      throw Exception("Пользователь не авторизован.");
    case 403:
      throw Exception("Нет прав.");
    default:
      throw Exception(response.reasonPhrase);
  }
}
