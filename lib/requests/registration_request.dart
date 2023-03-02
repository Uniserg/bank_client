import 'dart:convert';

import 'package:client/dto/registration_form.dart';
import 'package:http/http.dart' as http;

import '../vars/request_vars.dart';

Future<http.Response> register(RegistrationForm registrationForm) async {
  return http.post(
    Uri.parse("http://$appServerAddress/individuals/register"),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(registrationForm),
  );
}
