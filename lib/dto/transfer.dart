import 'package:json_annotation/json_annotation.dart';

part 'transfer.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Transfer {
  final String cardNumberFrom;
  final String cardNumberTo;
  final DateTime? createdAt;
  final double amount;
  final String? sessionSub;
  final String? message;
  final String? nameFrom;
  final String? nameTo;

  Transfer(
      {required this.cardNumberFrom,
      required this.cardNumberTo,
      this.createdAt,
      required this.amount,
      this.sessionSub,
      this.message, this.nameFrom, this.nameTo,
      });

  factory Transfer.fromJson(Map<String, dynamic> json) =>
      _$TransferFromJson(json);
  Map<String, dynamic> toJson() => _$TransferToJson(this);
}
