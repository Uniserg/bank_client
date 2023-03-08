import 'package:client/requests/card_requests.dart';
import 'package:client/vars/session_vars.dart';
import 'package:client/widgets/card.dart';
import 'package:client/widgets/card_add.dart';
import 'package:client/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dto/debit_card.dart';
import 'login.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final _savedCards = <DebitCard>[];
  final int batchSize = 5;

  void _logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future _updateSavedCard() async {
    getDebitCards(_savedCards.length, batchSize).then((cardList) => {
          setState(() {
            _savedCards.addAll(cardList);
          })
        });
  }

  @override
  void initState() {
    super.initState();
    _updateSavedCard();
  }

  @override
  Widget build(BuildContext context) {
    var quitDialog = Dialog(
      child: Container(
        padding: const EdgeInsets.all(18.0),
        width: 300,
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Вы действительно хотите выйти? Данные о сессии будут удалены.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      _logOut();

                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginWidget()));
                    },
                    child: const Text('Да'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Нет'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );

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

    return Scaffold(
      appBar: AppBar(
          title: Text("Добро пожаловать, ${accessTokenContext!.firstName}"),
          toolbarHeight: 100,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => quitDialog);
            },
            icon: const Icon(Icons.exit_to_app),
            //replace with our own icon data.
          )),
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        onRefresh: _updateSavedCard,
        child: ListView(
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 15,
                ),
                Expanded(child: SearchWidget()),
                SizedBox(width: 15),
                CircleAvatar(
                  radius: 30,
                ),
                SizedBox(width: 15),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 100, left: 5, right: 5),
              height: 200,
              decoration: const ShapeDecoration(
                  color: Color(0xffF5F0E5),
                  shape: RoundedRectangleBorder(
                      // side: BorderSide(color: Color(0xffD8AC42), width: 4),
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if (_savedCards.isEmpty)
                    emptyWalletMessage
                  else
                    for (var card in _savedCards)
                      CardWidget(
                        name: card.productName,
                        number: card.number.substring(card.number.length - 4),
                        balance: 0,
                      ),
                  const CardAddWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
