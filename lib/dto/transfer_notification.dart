import 'package:json_annotation/json_annotation.dart';

part 'transfer_notification.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TransferNotification {
  final DateTime createdAt;
  final double amount;
  final String? message;
  final String userSubFrom;
  final String cardNumberFrom4Postfix;
  final String cardNumberTo;

  TransferNotification({
    required this.createdAt,
    required this.amount,
    required this.message,
    required this.userSubFrom,
    required this.cardNumberFrom4Postfix,
    required this.cardNumberTo
  });

  factory TransferNotification.fromJson(Map<String, dynamic> json) => _$TransferNotificationFromJson(json);
  // Map<String, dynamic> toJson() => _$TransferToJson(this);
}