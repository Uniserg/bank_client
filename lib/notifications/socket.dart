import 'dart:convert';
import 'dart:async';

import 'package:client/dto/debit_card.dart';
import 'package:client/dto/socket_message.dart';
import 'package:client/main.dart';
import 'package:client/requests/keycloak_requests.dart';
import 'package:client/vars/request_vars.dart';
import 'package:client/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../dto/transfer_notification.dart';


WebSocketChannel? channel;

Stream<TransferNotification>? notifications;

void openSocketChannel() async {

  String? accessToken = await KeycloakAuth.getAccessToken();
  if (accessToken == null) {
    return;
  }

  channel = WebSocketChannel.connect(
    Uri.parse('ws://$appServerAddress/notifications/$accessToken'),
  );


  final Stream<SocketMessage> mainStream = channel!.stream.map((message) => SocketMessage.fromJson(json.decode(message)));

  notifications = mainStream
      .where((message) => message.scope == Scope.NOTIFICATION)
      .map((n) => TransferNotification.fromJson(n.body)).asBroadcastStream();


  notifications!.listen((message) {

    BuildContext context = navigatorKey.currentContext!;

    DebitCard card = cardsNotifier.cards[message.cardNumberTo]!;
    card.balance += message.amount;
    cardsNotifier.modify(message.cardNumberTo, card);

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.down,
          duration: Duration(seconds: 10),
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            margin: const EdgeInsets.only(
                bottom: 20,
                right: 30,
                left: 30),
            content: ListTile
              (
          onTap: () {

            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            Navigator
                .push(
                context,
                MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text("Информация по переводу"),
                      ),
                    )
                )
            );
          },
          leading: const Icon(Icons.add_card, color: Colors.green,),
                title: const Text("Перевод", style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Text("${'•' * 12}${message.cardNumberTo.substring(12)}"),
            trailing: Text(
                "+${message.amount}",
              style: TextStyle(fontSize: 18, color: Colors.green),

            )
            )
        )
    );
    // ScaffoldMessenger.maybeOf(context)?.showSnackBar(
    //   SnackBar(content: Text("Пришли деньги на сумму: ${message.amount}"))
    // );
  });


  var subscription2 = notifications!.listen((event) {
    print("А это уже другая подписка - сумма: ${event.amount}");
  });
}


