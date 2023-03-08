import 'dart:io';

import 'package:client/requests/keycloak_requests.dart';
import 'package:client/utils/jwt.dart';
import 'package:client/vars/session_vars.dart';
import 'package:client/widgets/home.dart';
import 'package:client/widgets/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dto/keycloak_auth.dart';

void main() {
  // Переопределяем политику сертификатов, потому что у меня самоподписанный сертификат, который не поддерживается
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void _makeAutologin() async {
  final prefs = await SharedPreferences.getInstance();

  accessToken = prefs.getString("accessToken");

  if (accessToken == null) {
    return;
  }

  accessTokenContext = AccessTokenJWTContext.fromJson(parseJwt(accessToken!));

  if (accessTokenContext!.exp < DateTime.now().microsecondsSinceEpoch) {
    logInWithRefreshToken();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    _makeAutologin();

    var widget =
        (accessToken == null) ? const LoginWidget() : const HomeWidget();

    return MaterialApp(
      title: 'Bank app',
      theme: ThemeData(
          primarySwatch: Colors.blue, primaryColor: const Color(0xffD8AC42)),
      home: widget,
    );
  }
}
