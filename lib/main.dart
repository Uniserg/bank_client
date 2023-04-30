import 'dart:io';

import 'package:client/notifications/socket.dart';
import 'package:client/requests/keycloak_requests.dart';
import 'package:client/widgets/home.dart';
import 'package:client/widgets/login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'exceptions/auth_errors.dart';

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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad
          },
        ),
      navigatorKey: navigatorKey,
        title: 'Bank app',
        theme: ThemeData(
            primarySwatch: Colors.blue, primaryColor: const Color(0xffD8AC42),
        ),
        home: FutureBuilder(
            future: KeycloakAuth.getAccessToken(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }

              if (snapshot.data == null ||
                  snapshot.error.runtimeType == NoAuthException) {
                return const LoginWidget();
              }

              openSocketChannel();

              return const HomeWidget();
            }));
  }
}
