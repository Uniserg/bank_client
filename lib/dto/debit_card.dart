import 'package:json_annotation/json_annotation.dart';

part 'debit_card.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DebitCard {
  String number;
  String holderName;
  DateTime expirationDate;
  double cvv;
  bool active;
  String productName;

  DebitCard(
      {required this.number,
      required this.holderName,
      required this.expirationDate,
      required this.cvv,
      required this.active,
      required this.productName});

  factory DebitCard.fromJson(Map<String, dynamic> json) =>
      _$DebitCardFromJson(json);
}
