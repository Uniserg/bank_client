import 'package:flutter/material.dart';

import '../requests/keycloak_requests.dart';
import 'login.dart';

class FutureWidget extends StatelessWidget {
  final Widget child;

  const FutureWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    var widget = FutureBuilder<String?>(
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return child;
        } else {
          return const LoginWidget();
        }
      },
      future: KeycloakAuth.getAccessToken(),
    );

    return widget;
  }
}
