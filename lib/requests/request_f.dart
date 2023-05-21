import 'package:client/requests/keycloak_requests.dart';
import 'package:client/widgets/login.dart';
import 'package:flutter/material.dart';

Future<dynamic> makeRequestWithAuth(
    BuildContext context, Future Function(String) f) async {
  var accessToken = await KeycloakAuth.getAccessToken();

  if (accessToken == null) {
    Navigator.popUntil(context, (route) => false);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginWidget()));
    return null;
  }

  return f(accessToken);
}
