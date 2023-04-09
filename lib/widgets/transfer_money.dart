import 'package:client/dto/debit_card.dart';
import 'package:client/dto/profile.dart';
import 'package:client/dto/transfer.dart';
import 'package:client/requests/keycloak_requests.dart';
import 'package:client/requests/request_f.dart';
import 'package:client/requests/transfer_requests.dart';
import 'package:client/widgets/action_tile_button.dart';
import 'package:client/widgets/custom_text_field.dart';
import 'package:client/widgets/profile.dart';
import 'package:client/widgets/registration.dart';
import 'package:client/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'card.dart';

class TransferTypeDialog extends StatelessWidget {
  final DebitCard cardNumberFrom;

  const TransferTypeDialog({super.key, required this.cardNumberFrom});

  @override
  Widget build(BuildContext context) {
    var actions = [
      ActionTileButton(
          title: "Другу", icon: Icons.account_circle, onTap: () {}),
      ActionTileButton(
          title: "По номеру телефона",
          icon: Icons.phone,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchByPhoneWidget(
                          cardNumberFrom: cardNumberFrom,
                        )));
          }),
      ActionTileButton(
          title: "По номеру карты",
          icon: Icons.credit_card,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchByCardNumberWidget(
                          cardNumberFrom: cardNumberFrom,
                        )));
          }),
      ActionTileButton(
          title: "Между счетами", icon: Icons.compare_arrows, onTap: () {}),
      ActionTileButton(
          title: "По реквизитам счета", icon: Icons.request_page, onTap: () {}),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.all(5),
          height: 4,
          width: MediaQuery.of(context).size.width * .2,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(30)),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: actions,
          ),
        )
      ],
    );
  }
}

class TransferMoneyWidget extends StatefulWidget {
  DebitCard selectedCardFrom;
  final String selectedCardNumberTo;
  final Profile profile;

  TransferMoneyWidget({
    super.key,
    required this.selectedCardFrom,
    required this.selectedCardNumberTo,
    required this.profile,
  });

  @override
  State<TransferMoneyWidget> createState() => _TransferMoneyWidgetState();
}

class _TransferMoneyWidgetState extends State<TransferMoneyWidget> {
  String? selectedCard;
  final transferSum = FieldState();
  final message = FieldState();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    selectedCard ??= widget.selectedCardFrom.number;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Перевести"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CardShape(
                        color: Theme.of(context).colorScheme.primary,
                        child: Center(
                          child: AnimatedBuilder(
                            animation: cardsNotifier,
                            builder: (BuildContext context, Widget? child) {
                              return DropdownButton(
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                                  dropdownColor:
                                  Theme.of(context).colorScheme.primary,
                                  style: TextStyle(
                                      color:
                                      Theme.of(context).colorScheme.onPrimary,
                                      fontSize: 16),
                                  itemHeight: 80,
                                  value: selectedCard,
                                  items: cardsNotifier.cards.values
                                      .map((e) => DropdownMenuItem(
                                      value: e.number,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            Text(e.number),
                                            Text(e.productName),
                                            Text(
                                                "${e.balance.toStringAsFixed(2)} ₽")
                                          ],
                                        ),
                                      )))
                                      .toList(),
                                  onChanged: (item) => setState(() {
                                    selectedCard = item;
                                    // TODO: улучшить способ
                                    widget.selectedCardFrom =
                                    cardsNotifier.cards[item]!;
                                  }));
                            },
                            // child: DropdownButton(
                            //     borderRadius:
                            //         const BorderRadius.all(Radius.circular(25)),
                            //     dropdownColor:
                            //         Theme.of(context).colorScheme.primary,
                            //     style: TextStyle(
                            //         color:
                            //             Theme.of(context).colorScheme.onPrimary,
                            //         fontSize: 16),
                            //     itemHeight: 80,
                            //     value: selectedCard,
                            //     items: cardsNotifier.cards.values
                            //         .map((e) => DropdownMenuItem(
                            //             value: e.number,
                            //             child: Container(
                            //               padding: const EdgeInsets.all(8),
                            //               child: Column(
                            //                 children: [
                            //                   Text(e.number),
                            //                   Text(e.productName),
                            //                   Text(
                            //                       "${e.balance.toStringAsFixed(2)} ₽")
                            //                 ],
                            //               ),
                            //             )))
                            //         .toList(),
                            //     onChanged: (item) => setState(() {
                            //           selectedCard = item;
                            //           // TODO: улучшить способ
                            //           widget.selectedCardFrom =
                            //               cardsNotifier.cards[item]!;
                            //         })),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_downward_rounded,
                        size: 50,
                        color: Theme.of(context).primaryColor,
                      ),
                      CardShape(
                          child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfilePage(profile: widget.profile)));
                        },
                        tileColor:
                            Theme.of(context).primaryColor.withOpacity(0.9),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        title: Text(
                            "${widget.profile.lastName} ${widget.profile.firstName}"),
                        subtitle: Text("•" * 12 +
                            widget.selectedCardNumberTo.substring(
                                widget.selectedCardNumberTo.length - 4)),
                        leading: const CircleAvatar(),
                      )),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      labelText: "Сумма перевода",
                      controller: transferSum.controller,
                      inputFormatters: [
                        FilteringTextInputFormatter(RegExp(r'[^[\d.]'),
                            allow: false),
                        LengthLimitingTextInputFormatter(20)
                      ],
                      validator: (str) {
                        if (str == null || str.isEmpty) {
                          return "Введите сумму";
                        }

                        var transferSum = double.tryParse(str);

                        if (transferSum == null) {
                          return "Не число";
                        }

                        if (transferSum > widget.selectedCardFrom.balance) {
                          return "Недостаточно средств.";
                        }

                        if (transferSum <= 0) {
                          return "Сумма должна быть больше 0";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 30,),

                    CustomTextField(
                        labelText: "Сообщение",
                        controller: message.controller,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(256)
                      ],
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 40),
                width: 200,
                height: 60,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).colorScheme.primary),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).colorScheme.onPrimary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ))),
                  onPressed: () {
                    final isValidForm = formKey.currentState!.validate();

                    if (!isValidForm) {
                      return;
                    }

                    Transfer transfer = Transfer(
                      cardNumberFrom: widget.selectedCardFrom.number,
                      cardNumberTo: widget.selectedCardNumberTo,
                      amount: double.parse(transferSum.controller.text),
                      message: message.controller.text == ""?null:message.controller.text
                    );

                    makeRequestWithAuth(
                        context,
                        (token) =>
                            createTransfer(token, transfer).then((transfer) {
                              DebitCard card =
                                  cardsNotifier.cards[transfer.cardNumberFrom]!;
                              card.balance -= transfer.amount;
                              cardsNotifier.modify(card.number, card);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CompletedTransferWidget(
                                          transfer: transfer,
                                          profileTo: widget.profile,
                                        )),
                              );
                            }));
                  },
                  child: const Text('Перевести'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TransferCardWidget extends StatelessWidget {
  final Color color;
  final String cardNumber4Postfix;
  final String holderName;

  const TransferCardWidget(
      {super.key,
      required this.color,
      required this.holderName,
      required this.cardNumber4Postfix});

  @override
  Widget build(BuildContext context) {
    return CardShape(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
                child: Text(
              "${"•" * 12}$cardNumber4Postfix",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            )),
          ),
          Container(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.only(bottom: 10, right: 10),
            child: Text(
              holderName,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          )
        ],
      ),
    );
  }
}

class CompletedTransferWidget extends StatelessWidget {
  final Transfer transfer;
  final Profile profileTo;

  const CompletedTransferWidget(
      {super.key, required this.transfer, required this.profileTo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 25),
        child: Column(
          children: [
            const Center(
                child: Icon(
              Icons.check,
              size: 80,
              color: Colors.green,
            )),
            const Text(
              "Перевод выполнен успешно",
              style: TextStyle(color: Colors.green, fontSize: 24),
            ),
            const SizedBox(
              height: 40,
            ),
            TransferCardWidget(
                color: Theme.of(context).colorScheme.primary,
                holderName:
                    "${KeycloakAuth.getAccessTokenContext()!.lastName} ${KeycloakAuth.getAccessTokenContext()!.firstName} ",
                cardNumber4Postfix: transfer.cardNumberFrom.substring(12)),
            Column(
              children: [
                Center(
                  child: Text(
                    "-${transfer.amount}",
                    style:
                        const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Icon(
                    Icons.arrow_downward_rounded,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Center(
                  child: Text(
                    "+${transfer.amount}",
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            TransferCardWidget(
                color: Theme.of(context).primaryColor,
                holderName: "${profileTo.lastName} ${profileTo.firstName}",
                cardNumber4Postfix: transfer.cardNumberTo.substring(12)),
            Container(
              margin: EdgeInsets.only(top: 40),
              width: 200,
              height: 60,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.primary),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.onPrimary),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ))),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('На главный экран'),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
