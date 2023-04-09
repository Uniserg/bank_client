import 'package:client/dto/account_requisites.dart';
import 'package:client/dto/debit_card.dart';
import 'package:client/requests/request_f.dart';
import 'package:client/utils/formatters.dart';
import 'package:client/vars/decorations.dart';
import 'package:client/vars/my_colors_dev.dart';
import 'package:client/widgets/transfer_money.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../dto/transfer.dart';
import '../notifiers/cards_notifier.dart';
import '../requests/card_requests.dart';
import 'card_add.dart';

CardsNotifier cardsNotifier = CardsNotifier();

class CardShape extends StatelessWidget {
  final Widget? child;
  final double width;
  final double height;
  final Color? color;

  const CardShape({
    super.key,
    this.child,
    this.width = 250,
    this.height = 150,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.transparent),
        borderRadius: const BorderRadius.all(
            Radius.circular(20.0) //                 <--- border radius here
            ),
      ),
      child: child,
    );
  }
}

class CardWidget extends StatelessWidget {
  final String? number;
  final double? balance;
  final List<int>? logo;
  final String name;
  final void Function()? onPressed;

  final EdgeInsetsGeometry? margin;

  const CardWidget({
    required this.name,
    super.key,
    this.number = "",
    this.logo,
    this.balance,
    this.onPressed,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(
        margin: margin,
        width: 250,
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius: const BorderRadius.all(
              Radius.circular(20.0) //                 <--- border radius here
              ),
        ),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(myLightBlue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          onPressed: onPressed,
          child: Stack(
            children: [
              Center(
                  child: Text(name,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 24))),
              Positioned(
                  bottom: 10,
                  right: 20,
                  child: Text(
                      (balance == null)
                          ? ""
                          : "${balance!.toStringAsFixed(2)}₽",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 24))),
              Positioned(
                  bottom: 10,
                  left: 20,
                  child: Text("$number",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18))),
            ],
          ),
        ),
      ),
    );
  }
}

class CardList extends StatefulWidget {
  const CardList({super.key});

  @override
  State<CardList> createState() => CardListState();
}

class CardListState extends State<CardList> {
  final int batchSize = 10;

  final ScrollController _scrollController = ScrollController();

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      makeRequestWithAuth(context, cardsNotifier.loadNewCards);
    }
  }

  @override
  void initState() {
    super.initState();
    makeRequestWithAuth(context, cardsNotifier.reloadCards);
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    var emptyWalletMessage = Container(
      padding: const EdgeInsets.only(left: 20),
      width: 300,
      child: Center(
        child: Text(
          'У вас не открыто ни одного счета. Нажмите "Заказать карту", чтобы открыть новый счет.',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary, fontSize: 16),
        ),
      ),
    );

    return AnimatedBuilder(
        animation: cardsNotifier,
        builder: (BuildContext context, Widget? child) {
          return Container(
            margin: const EdgeInsets.only(top: 50, left: 5, right: 5),
            height: 200,
            decoration: const ShapeDecoration(
                color: Color(0xffF5F0E5),
                shape: RoundedRectangleBorder(
                    // side: BorderSide(color: Color(0xffD8AC42), width: 4),
                    borderRadius: BorderRadius.all(Radius.circular(20)))),
            child: ListView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              children: [
                if (cardsNotifier.cards.isEmpty)
                  emptyWalletMessage
                else
                  for (var card in cardsNotifier.cards.values)
                    AnimatedBuilder(
                      animation: cardsNotifier,
                      builder: (BuildContext context, Widget? child) {
                        return CardWidget(
                          margin: const EdgeInsets.only(left: 20),
                          name: card.productName,
                          number: card.number.substring(card.number.length - 4),
                          balance: card.balance,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CardDetailsWidget(
                                        debitCard: card,
                                        number: card.number,
                                        holderName: card.holderName,
                                        expirationDate: DateFormat("MM/yy")
                                            .format(card.expirationDate),
                                        cvv: card.cvv.toInt(),
                                        isActive: card.active,
                                        productName: card.productName)));
                          },
                        );
                      },
                    ),
                const CardAddWidget(),
              ],
            ),
          );
        });
  }
}

class AccountRequisite extends StatelessWidget {
  final String requisiteName;
  final String value;

  const AccountRequisite(
      {super.key, required this.requisiteName, required this.value});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 25),
        child: Column(
          children: [
            Text(
              requisiteName,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            SelectableText(
              value,
              style: const TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}

class AccountRequisiteList extends StatelessWidget {
  final AccountRequisites accountRequisites;

  const AccountRequisiteList({super.key, required this.accountRequisites});

  @override
  Widget build(BuildContext context) {
    var requisites = [
      AccountRequisite(
          requisiteName: "Номер счета", value: accountRequisites.number),
      AccountRequisite(
          requisiteName: "Название банка получателя",
          value: accountRequisites.bankName),
      AccountRequisite(requisiteName: "БИК", value: accountRequisites.bik),
      AccountRequisite(
          requisiteName: "Корр. счет",
          value: accountRequisites.correspondAccount),
      AccountRequisite(requisiteName: "ИНН", value: accountRequisites.inn),
      AccountRequisite(requisiteName: "КПП", value: accountRequisites.kpp),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Реквизиты счета",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: requisites,
          ),
        ),
      ),
    );
  }
}

class CardDetailsWidget extends StatelessWidget {
  final DebitCard debitCard;
  final String number;
  final String holderName;
  final String expirationDate;
  final int cvv;
  final bool isActive;
  final String productName;

  const CardDetailsWidget(
      {super.key,
      required this.number,
      required this.holderName,
      required this.expirationDate,
      required this.cvv,
      required this.isActive,
      required this.productName,
      required this.debitCard});

  @override
  Widget build(BuildContext context) {
    var cardShape = Container(
      margin: const EdgeInsets.all(20),
      child: CardShape(
        width: 120,
        height: 80,
        color: Theme.of(context).colorScheme.primary,
        child: Container(
          alignment: Alignment.bottomLeft,
          margin: const EdgeInsets.all(8),
          child: Text(
            number.substring(number.length - 4),
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ),
    );

    var actionsButtons = [
      TextButton(
        onPressed: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_rounded,
                color: Theme.of(context).colorScheme.primary),
            Text("Пополнить",
                style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ],
        ),
      ),
      TextButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) => TransferTypeDialog(
                    cardNumberFrom: debitCard,
                  ));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_circle_right,
              color: Theme.of(context).colorScheme.primary,
            ),
            Text("Перевести",
                style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ],
        ),
      ),
      TextButton(
        onPressed: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.contactless_sharp,
                color: Theme.of(context).colorScheme.primary),
            Text("Оплатить",
                style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ],
        ),
      ),
    ];

    var accountOperationsButton = Flexible(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(5),
        height: 100,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AccountOperationsWidget(cardNumber: number))
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(beige),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Операции по счету",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        ),
      ),
    );

    var accountRequisites = Flexible(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(5),
        height: 100,
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: beige,
                content: FutureBuilder(
                    future: makeRequestWithAuth(
                        context,
                        (token) =>
                            getAccountRequisitesByCardNumber(token, number)),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }

                      return AccountRequisiteList(
                          accountRequisites: snapshot.data!);
                    }),
              ),
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(beige),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Реквизиты счета",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        ),
      ),
    );

    var accountActions = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 340,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [accountOperationsButton, accountRequisites],
        ),
      ),
    );

    var cardRequisites = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 340,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: beigeGoldFieldDecoration,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Реквизиты карты",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                ),
                Expanded(
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Показать",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        )))
              ],
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(8),
              decoration: lightGoldFieldDecoration,
              child: Row(
                children: [
                  SelectableText(
                    number,
                    style: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: const Icon(
                          Icons.copy,
                          color: Colors.grey,
                        )),
                  )
                ],
              ),
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(10),
                    decoration: lightGoldFieldDecoration,
                    child: Row(
                      children: [
                        SelectableText(
                          expirationDate,
                          style: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: const Icon(
                                Icons.copy,
                                color: Colors.grey,
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(10),
                    height: 50,
                    decoration: lightGoldFieldDecoration,
                    child: Row(
                      children: [
                        SelectableText(
                          cvv.toString(),
                          style: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: const Icon(
                                Icons.copy,
                                color: Colors.grey,
                              )),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              cardShape,
              Container(
                // actionBar
                margin: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: 340,
                    decoration: beigeGoldFieldDecoration,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: actionsButtons),
                  ),
                ),
              ),
              accountActions,
              cardRequisites
            ],
          ),
        ),
      ),
    );
  }
}



class TransferList extends StatefulWidget {

  final String cardNumber;

  const TransferList({
    super.key,
    required this.cardNumber,
  });

  @override
  State<TransferList> createState() => _TransferListState();
}

class _TransferListState extends State<TransferList> {
  final int batchSize = 20;

  final ScrollController _scrollController = ScrollController();

  final List<Transfer> _transfers = <Transfer>[];

  Future _updateTransfers(String accessToken) async {
    getAllTransfersByCardNumber(accessToken, widget.cardNumber, _transfers.length, batchSize).then((transfers) => {
      setState(() {
        _transfers.addAll(transfers);
      })
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      makeRequestWithAuth(context, _updateTransfers);
    }
  }

  @override
  void initState() {
    super.initState();
    makeRequestWithAuth(context, _updateTransfers);
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {

    isIncome(e) => cardsNotifier.cards.containsKey(e.cardNumberTo);

    get4Postfix(String cardNumber) => "${"•" * 12}${cardNumber.substring(12)}";

    return RefreshIndicator(
      onRefresh: () async {
        _transfers.clear();
        makeRequestWithAuth(context, _updateTransfers);
      },
      child: ListView(
        controller: _scrollController,
        children: _transfers.map((e) => ListTile(
          onTap: () {},
          title: Text("${isIncome(e)?e.nameFrom:e.nameTo} - ${isIncome(e)?get4Postfix(e.cardNumberFrom):get4Postfix(e.cardNumberTo)}",
              style: TextStyle(color: isIncome(e)
                  ?Colors.green
                  :Colors.red),
          ),
          subtitle: Row(
            children: [
              Text(dateFormatter.format(e.createdAt!)),
              Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(left: 25),
                    child: Text(
                      e.message == null?"":e.message!,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
              ),
            ],
          ),
          leading: isIncome(e)
              ?const Icon(Icons.arrow_circle_right_rounded, color: Colors.green,)
              :const Icon(Icons.arrow_circle_left_rounded, color: Colors.red,),
          trailing: Text(
              "${isIncome(e)?'+':'-'}${e.amount.toString()}",
            style: TextStyle(
              color: isIncome(e)
                  ?Colors.green
                  :Colors.red
            ),
          ),
        ))
            .toList(),
      ),
    );
  }
}

class AccountOperationsWidget extends StatelessWidget {

  final String cardNumber;

  const AccountOperationsWidget({
    super.key,
    required this.cardNumber
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Операции по счету"),),
      body: TransferList(cardNumber: cardNumber,),
    );
  }
}
