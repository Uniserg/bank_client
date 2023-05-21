import 'package:flutter/cupertino.dart';

import '../dto/debit_card.dart';
import '../requests/card_requests.dart';

class CardsNotifier extends ChangeNotifier {
  final Map<String, DebitCard> cards = {};
  final int batchSize = 10;

  void addAll(List<DebitCard> cardList) {
    for (var card in cardList) {
      cards[card.number] = card;
    }
    notifyListeners();
  }

  void modify(String cardNumber, DebitCard card) {
    cards[cardNumber] = card;
    notifyListeners();
  }

  void clear() {
    cards.clear();
    notifyListeners();
  }

  Future loadNewCards(String accessToken) async {
    getDebitCards(accessToken, cards.length, batchSize).then((cardList) {
      addAll(cardList);
    });
  }

  Future reloadCards(String accessToken) async {
    cards.clear();
    loadNewCards(accessToken);
  }
}
