import 'dart:io';

import 'package:client/requests/keycloak_requests.dart';
import 'package:client/widgets/home.dart';
import 'package:client/widgets/login.dart';
import 'package:client/widgets/orders.dart';
import 'package:client/widgets/products.dart';
import 'package:flutter/material.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    var home = FutureBuilder<String?>(
      builder: (context, snapshot) {

        if (snapshot.data != null) {
          return const HomeWidget();
        } else {
          return const LoginWidget();
        }
      },
      future: KeycloakAuth.getAccessToken(),
    );

    return MaterialApp(
      title: 'Bank app',
      theme: ThemeData(
          primarySwatch: Colors.blue, primaryColor: const Color(0xffD8AC42)),
      home: home,
    );
  }
}
