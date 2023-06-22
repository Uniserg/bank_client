import 'package:json_annotation/json_annotation.dart';

part 'debit_card.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DebitCard {
  final String number;
  final String holderName;
  final DateTime expirationDate;
  double balance;
  final int cvv;
  bool active;
  final String productName;

  DebitCard(
      {required this.number,
      required this.holderName,
      required this.expirationDate,
      required this.balance,
      required this.cvv,
      required this.active,
      required this.productName});

  factory DebitCard.fromJson(Map<String, dynamic> json) =>
      _$DebitCardFromJson(json);
}
